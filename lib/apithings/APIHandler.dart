import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:cwatch/apithings/fakeDataGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_json/pretty_json.dart';
import 'package:random_string/random_string.dart';

import 'package:cwatch/app/history/historyview.dart';
import 'package:cwatch/app/models/datamodel.dart';
import 'package:cwatch/app/models/weathermodel.dart';

enum AllActiveLocations { Abuja, Accra, Abidjan }

class APIHandler {
  final String APIKEY = '6489a7ca3aa40421818eb351a8f77b6a';
  final String abjLang = '9.0765';
  final String abjLong = '7.3986';
  final String acrraLang = '5.6148';
  final String accraLong = '-0.2058';
  final String abjnLang = '5.30966';
  final String abjnLong = '-4.01266';
  Map<String, Map<String, List<FakeData>>> alldata = {};
  FakeDataGenerator _fakeDataGenerator = FakeDataGenerator();

  FirebaseFunctions functions = FirebaseFunctions.instance;
  //for fetching all updated data for the day, from all locations
  List<LocationDataModel> datahistory = [];
  List<CurrentandForecast> thongs = [];

  APIHandler() {
    // functions.useFunctionsEmulator(origin: 'http://localhost:5001');
  }
  Future<CurrentandForecast> getDataOneCall(location) async {
    // return [];
    Map<String, String> locationsLatLong = {
      abjLang: abjLong,
      acrraLang: accraLong,
      abjnLang: abjnLong
    };
    // await sendFetchAllDataHistory([]);
    // return CurrentandForecast.fromMap({});
    return await getLocationWeatherData(location);
    for (var i = 0; i < locationsLatLong.length; i++) {
      var key = locationsLatLong.keys.elementAt(i);
      var value = locationsLatLong.values.elementAt(i);
      String url =
          'https://api.openweathermap.org/data/2.5/onecall?lat=$key&lon=$value&exclude={minutely,hourly,alerts}&appid=$APIKEY';
      http.Response res = await http.get(Uri.parse(url));
      // print(res.body);
      var thong = CurrentandForecast.fromMap(jsonDecode(res.body));
      thongs.add(thong);
    }
    // return thongs;
  }

  Map<String, CurrentandForecast> hack = {};
  Future<CurrentandForecast> getLocationWeatherData(
      String enteredLocation) async {
    if (hack[enteredLocation] != null) {
      CurrentandForecast thing = hack[enteredLocation]!;
      return Future.value(thing);
    }
    String latitude = '';
    String longitude = '';
    switch (enteredLocation) {
      case 'Abuja':
        latitude = abjLang;
        longitude = abjLong;
        break;
      case 'Accra':
        latitude = acrraLang;
        longitude = accraLong;
        break;
      case 'Abidjan':
        latitude = abjnLang;
        longitude = abjnLong;
        break;
      default:
        break;
    }
    var waetherData = _fakeDataGenerator.getWeatherAPI(latitude, longitude);
    // HttpsCallable callable =
    //     FirebaseFunctions.instance.httpsCallable('getWeatherAPI');
    // var responseData = await callable.call({
    //   'latitude': latitude,
    //   'longitude': longitude,
    //   'location': enteredLocation,
    //   'date': DateTime(
    //           DateTime.now().year, DateTime.now().month, DateTime.now().day)
    //       .microsecondsSinceEpoch
    //       .toString()
    // });
    // var locationData =
    //     CurrentandForecast.fromMap(jsonDecode(jsonEncode(responseData.data)));
    var locationData = CurrentandForecast.fromMap(waetherData);
    print(locationData.toString());
    hack.addAll({enteredLocation: locationData});
    return locationData;
  }

  Future<void> loadHistory() async {
    List<String> _dateRange = [];
    //fetch since doesnt exist yet
    if (_dateRange.isEmpty) {
      final DateTime rangeStartDate = DateTime(2021, 07, 1);
      final DateTime rangeEndDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      for (int i = 0;
          i <= rangeEndDate.difference(rangeStartDate).inDays;
          i++) {
        var newdate = rangeStartDate.add(Duration(days: i)).toString();
        _dateRange.add(newdate);
      }
    }
    List<String> formatted = [];
    if (_dateRange.isNotEmpty) {
      _dateRange.forEach((date) {
        formatted.add(DateTime.parse(date)
            .add(Duration(days: 0, hours: 0))
            .microsecondsSinceEpoch
            .toString());
      });
      var unmappedData = _fakeDataGenerator.allData["allData"];
      print(unmappedData);
      // HttpsCallable callable =
      //     FirebaseFunctions.instance.httpsCallable('retrieveAllData');
      // var responseData = await callable.call({'dates': formatted});
      // print(responseData.data);
      // Map<String, dynamic> unmappedData = responseData.data;
      // print(responseData.data);
      Map<String, Map<String, List<FakeData>>> alldata = {};
      List<FakeData> fakedata = [];
      Map<String, List<FakeData>> dayData = {};
      for (var city = 0; city < 3; city++) {
        for (var day = 0; day < _dateRange.length; day++) {
          for (var hour = 0; hour < 24; hour++) {
            var hourEpoch = DateTime.parse(_dateRange[day])
                .add(Duration(hours: hour))
                .microsecondsSinceEpoch
                .toString();

            var tt = unmappedData[describeEnum(AllActiveLocations.values[city])]
                [formatted[day]][hourEpoch];

            fakedata.add(FakeData(
                temperature: tt["temperature"],
                humidity: tt["humidity"],
                pm: tt["pm"],
                ozone: tt["ozone"],
                pressure: tt["pressure"],
                time: DateTime.fromMicrosecondsSinceEpoch(int.parse(hourEpoch))
                    .toString(),
                gas: tt["gas"]));
          }
          dayData.addAll({
            DateTime.fromMicrosecondsSinceEpoch(int.parse(formatted[day]))
                .toString(): fakedata
          });
          fakedata = [];
        }

        alldata
            .addAll({describeEnum(AllActiveLocations.values[city]): dayData});
        // print(alldata);

        dayData = {};
      }
      this.alldata = alldata;
      print(this.alldata);
    }
  }

  Future<FakeData> getPrediction(String location) async {
    List<String> previous5 = [];
    List<String> currentHourPRevios5 = [];
    for (var i = 1; i < 6; i++) {
      previous5.add(DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .subtract(Duration(days: i))
          .microsecondsSinceEpoch
          .toString());
      currentHourPRevios5.add(DateTime(DateTime.now().year,
              DateTime.now().month, DateTime.now().day, DateTime.now().hour)
          .subtract(Duration(days: i))
          .microsecondsSinceEpoch
          .toString());
    }
    var responseData = _fakeDataGenerator.getPrediction(
        location, previous5, currentHourPRevios5);
    // HttpsCallable callable =
    //     FirebaseFunctions.instance.httpsCallable('getPrediction');
    // var responseData = await callable.call({
    //   'location': location,
    //   'previousDaysEpoch': previous5,
    //   'hourEpoch': currentHourPRevios5
    // });
    List unmapped = jsonDecode(jsonEncode(responseData)) as List;

    double temperature = 0;
    double humidity = 0;
    double pm = 0;
    double pressure = 0;
    double ozone = 0.0;
    for (var item in unmapped) {
      print(item["temperature"]);
      temperature += double.parse(item["temperature"]);
      humidity += double.parse(item["humidity"]);
      pm += double.parse(item["pm"]);
      ozone += double.parse(item["ozone"]);
      pressure += double.parse(item["pressure"]);
    }
    return FakeData(
        temperature: (temperature / 5).toString(),
        humidity: (humidity / 5).toString(),
        pm: (pm / 5).toString(),
        ozone: (ozone / 5).toString(),
        pressure: (pressure / 5).toString(),
        gas: '9');
  }

  sendFetchAllDataHistory(List<String> dateRange) async {
    //send fake data to cloud
    List<String> _dateRange = [];
    //fetch since doesnt exist yet
    if (_dateRange.isEmpty) {
      final DateTime rangeStartDate = DateTime(2021, 07, 1);
      final DateTime rangeEndDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      for (int i = 0;
          i <= rangeEndDate.difference(rangeStartDate).inDays;
          i++) {
        var newdate = rangeStartDate.add(Duration(days: i)).toString();
        _dateRange.add(newdate);
      }
    }
    Map<String, LocationDataModel> locationData = {};

    for (var location = 0;
        location < AllActiveLocations.values.length;
        location++) {
      Map<String, DailyDataModel> dayData = {};
      for (var i = 0; i < _dateRange.length; i++) {
        // print(_date   Range[i]);
        Map<String, HourlyDataModel> fkeData = {};
        for (var j = 0; j < 24; j++) {
          Random r = Random();
          PMTEMP(j);
          fkeData.addAll({
            DateTime.parse(_dateRange[i])
                    .add(Duration(hours: j))
                    .microsecondsSinceEpoch
                    .toString():
                HourlyDataModel(
                    temperature: temp,
                    pressure: randomBetween(23, 32).toString(),
                    pm: pm,
                    ozone: (r.nextDouble() * (0.054 - 0.049) + 0.049)
                        .toStringAsFixed(2),
                    gas: randomBetween(30, 40).toString(),
                    humidity: randomBetween(85, 91).toString())
          });
        }
        // print(fkeData);
        dayData.addAll({
          DateTime.parse(_dateRange[i]).microsecondsSinceEpoch.toString():
              DailyDataModel(
                  dayData: fkeData,
                  date: DateTime.parse(_dateRange[i])
                      .microsecondsSinceEpoch
                      .toString())
        });
        // print(dayData);

        locationData.addAll({
          describeEnum(AllActiveLocations.values[location]): LocationDataModel(
              location: describeEnum(AllActiveLocations.values[location]),
              locationData: dayData)
        });
      }
    }
    // print(locationData);

    Map<String, dynamic> all = {};
    Map<String, dynamic> thing = {};
    locationData.forEach((key, value) {
      thing.addAll(value.toMap());
    });

    all.addAll({"allData": thing});

    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendFakeData');
    await callable.call({'data': all});
  }

  String pm = '', temp = '';

  PMTEMP(int hr) {
    if (hr >= 21 || hr <= 6) {
      temp = randomBetween(21, 25).toDouble().toString();
      pm = randomBetween(40, 55).toDouble().toString();
    }
    if (hr >= 7 && hr <= 9) {
      temp = randomBetween(23, 27).toDouble().toString();
      pm = randomBetween(60, 65).toDouble().toString();
    }
    if (hr >= 10 && hr <= 14) {
      temp = randomBetween(28, 32).toDouble().toString();
      pm = randomBetween(65, 70).toDouble().toString();
    }
    if (hr >= 15 && hr <= 17) {
      temp = randomBetween(23, 27).toDouble().toString();
      pm = randomBetween(65, 70).toDouble().toString();
    }
    if (hr >= 18 && hr <= 20) {
      temp = randomBetween(23, 27).toDouble().toString();
      pm = randomBetween(65, 70).toDouble().toString();
    }
  }

  Future<void> fetchDataHistory(DateTime date) async {
    //fetch either current date, group of dates or all dates from time till now
    //if variable is empty, user wants all possible dates
    List<String> formatted = [];
    // if (dates.isNotEmpty) {
    //   dates.forEach((date) {
    formatted.add(date.toString());
    // });
    // }
    //fetch since doesnt exist yet
    var unmappedData = _fakeDataGenerator
        .fetchTodayData(date.microsecondsSinceEpoch.toString());
    // HttpsCallable callable =
    //     FirebaseFunctions.instance.httpsCallable('retrieveAllData');
    // var responseData = await callable.call({'dates': formatted});
    // print(responseData.data);
    // Map<String, dynamic> unmappedData =
    //     jsonDecode(jsonEncode(responseData.data));

    Map<String, LocationDataModel> locationData = {};

    for (var location = 0;
        location < AllActiveLocations.values.length;
        location++) {
      Map<String, DailyDataModel> dayData = {};
      for (var i = 0; i < 1; i++) {
        Map<String, HourlyDataModel> fkeData = {};
        for (var j = 0; j < 24; j++) {
          var tt =
              unmappedData[describeEnum(AllActiveLocations.values[location])][
                  DateTime.parse(formatted[i])
                      .add(Duration(hours: j))
                      .microsecondsSinceEpoch
                      .toString()];
          fkeData.addAll({
            DateTime.parse(formatted[i])
                    .add(Duration(hours: j))
                    .microsecondsSinceEpoch
                    .toString():
                HourlyDataModel(
                    temperature: tt["temperature"],
                    pressure: tt["pressure"],
                    pm: tt["pm"],
                    ozone: tt["ozone"],
                    gas: tt["gas"],
                    humidity: tt["humidity"])
          });
        }
        dayData.addAll({
          DateTime.parse(formatted[i]).microsecondsSinceEpoch.toString():
              DailyDataModel(
                  dayData: fkeData,
                  date: DateTime.parse(formatted[i])
                      .microsecondsSinceEpoch
                      .toString())
        });

        datahistory.add(LocationDataModel(
            location: describeEnum(AllActiveLocations.values[location]),
            locationData: dayData));
      }
    }
  }

  Future<void> downloadAllData() async {}

  Future<List<DayHistory>> loadSpecificHistroy(
      {required AllActiveLocations location, required int date}) async {
    var allItems = _fakeDataGenerator.loadSpecific(
        describeEnum(location), date.toString());
    // HttpsCallable callable =
    //     FirebaseFunctions.instance.httpsCallable('retrieveParticularData');
    // var responseData = await callable.call({
    //   'location': describeEnum(location),
    //   'date': date,
    // });
    // Map<String, dynamic> allItems = jsonDecode(jsonEncode(responseData.data));
    List<DayHistory> dayData = [];
    allItems.forEach((key, value) {
      dayData.add(DayHistory(date: key, data: HourlyDataModel.fromMap(value)));
    });

    return dayData;
  }
}

class DayHistory {
  String date;
  HourlyDataModel data;
  DayHistory({
    required this.date,
    required this.data,
  });
}
