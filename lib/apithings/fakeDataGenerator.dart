import 'dart:math';

import 'package:cwatch/apithings/APIHandler.dart';
import 'package:cwatch/app/models/datamodel.dart';
import 'package:flutter/foundation.dart';
import 'package:random_string/random_string.dart';

class FakeDataGenerator {
  FakeDataGenerator() {
    creteAllData();
  }
  getWeatherAPI(String lat, String log) {
    return {
      "lat": double.parse(lat),
      "lon": double.parse(log),
      "current": {
        "weather": [
          {
            "main": "Clouds",
            "description": "Broken Clouds",
          }
        ]
      },
      "daily": [
        {
          "weather": [
            {
              "main": "Rain",
              "description": "Light Rain",
            }
          ]
        }
      ]
    };
  }

  fetchTodayData(String date) {
    return {
      "Abuja": allData["allData"]["Abuja"][date],
      "Accra": allData["allData"]["Accra"][date],
      "Abidjan": allData["allData"]["Abidjan"][date],
    };
  }

  creteAllData() {
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
        // print(_dateRange.length);
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
        // print(DateTime.parse(_dateRange[i]).microsecondsSinceEpoch.toString());
        dayData.addAll({
          DateTime.parse(_dateRange[i]).microsecondsSinceEpoch.toString():
              DailyDataModel(
                  dayData: fkeData,
                  date: DateTime.parse(_dateRange[i])
                      .microsecondsSinceEpoch
                      .toString())
        });
        // print(dayData.length);

        locationData.addAll({
          describeEnum(AllActiveLocations.values[location]): LocationDataModel(
              location: describeEnum(AllActiveLocations.values[location]),
              locationData: dayData)
        });
      }
      // print(dayData);
    }
    print(locationData.length);

    Map<String, dynamic> all = {};
    Map<String, dynamic> thing = {};
    locationData.forEach((key, value) {
      thing.addAll(value.toMap());
    });

    all.addAll({"allData": thing});
    // print(thing);
    // print(all.length);
    this.allData = all;
  }

  Map<String, dynamic> allData = {};

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

  getPrediction(
      String location, List<String> previousDaysEpoch, List<String> hourEpoch) {
    List all = [];
    for (var i = 0; i < 5; i++) {
      var day = previousDaysEpoch[i];
      var currentTimeDay = hourEpoch[i];
      all.add(allData["allData"][location][day][currentTimeDay]);
    }
    return all;
  }

  loadSpecific(String location, String date) {
    return allData["allData"][location][date];
  }
}
