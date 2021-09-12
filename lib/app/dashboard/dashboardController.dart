import 'dart:math';

import 'package:cwatch/apithings/APIHandler.dart';
import 'package:cwatch/app/about/aboutView.dart';
import 'package:cwatch/app/history/historyview.dart';
import 'package:cwatch/app/mainapp.dart';
import 'package:cwatch/app/models/dashboardgraphmodel.dart';
import 'package:cwatch/app/models/datamodel.dart';
import 'package:cwatch/app/models/latestdatamodel.dart';
import 'package:cwatch/app/models/weathermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:timezone/standalone.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

import '../../main.dart';

enum weatherDataState { loading, error, success }
enum dashboardGraphState { loading, error, success }
enum DashMenuOptions { logout }

class DashboardController extends GetxController {
  RxInt currentgraphsSelection = 0.obs;
  APIHandler _handler = Get.find();
  Rx<CurrentandForecast> weatherData = CurrentandForecast(current: null).obs;
  Rx<weatherDataState> weatherstate = weatherDataState.loading.obs;
  RxList<FakeData> fakedata = <FakeData>[].obs;
  Rx<dashboardGraphState> graphstate = dashboardGraphState.loading.obs;
  RxBool graphradio = false.obs;
  RxList<DashboardGraphModel> graphdata = <DashboardGraphModel>[].obs;
  RxList<LocationDataModel> allData = <LocationDataModel>[].obs;

  Rx<AllActiveLocations> selectedLocation = AllActiveLocations.Abuja.obs;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  changeLocation(AllActiveLocations newlocation) {
    selectedLocation.value = newlocation;
    _getGraphData();
    _handler.getLocationWeatherData(describeEnum(newlocation));
  }

  _getGraphData() {
    if (allData.isEmpty) return;
    graphstate.value = dashboardGraphState.loading;
    List<DashboardGraphModel> data = [];
    int selected = allData.indexWhere(
        (element) => element.location == describeEnum(selectedLocation.value));
    LocationDataModel today = allData[selected];
    String currentDateEpoch =
        DateTime(2021, DateTime.now().month, DateTime.now().day - 1)
            .microsecondsSinceEpoch
            .toString();
    Map<String, HourlyDataModel> hours =
        today.locationData[currentDateEpoch]!.dayData;
    // Random rand = Random();
    // var stopwatch = Stopwatch()..start();
    for (var i = 0; i < DateTime.now().hour + 1; i++) {
      String hour = DateTime(2021, DateTime.now().month, DateTime.now().day - 1)
          .add(Duration(hours: i))
          .microsecondsSinceEpoch
          .toString();

      HourlyDataModel value = hours[hour]!;

      data.add(DashboardGraphModel(
          source: 'temp',
          value: LatestDataModel(
              gas: double.parse(value.gas),
              humidity: double.parse(value.humidity),
              ozone: double.parse(value.ozone),
              pm: double.parse(value.pm),
              pressure: double.parse(value.pressure),
              temperature: double.parse(value.temperature)),
          time: DateTime.fromMicrosecondsSinceEpoch(int.parse(hour))));
    }
    // hours.forEach((key, value) {
    //   data.add(DashboardGraphModel(
    //       source: 'temp',
    //       value: LatestDataModel(
    //           gas: double.parse(value.gas),
    //           humidity: double.parse(value.humidity),
    //           ozone: double.parse(value.ozone),
    //           pm: double.parse(value.pm),
    //           pressure: double.parse(value.pressure),
    //           temperature: double.parse(value.temperature)),
    //       time: DateTime.fromMicrosecondsSinceEpoch(int.parse(key))));
    // });
    graphdata.value = data;
    graphstate.value = dashboardGraphState.success;
    // Stopwatch().stop();
    // print('creating fake data is done ${stopwatch.elapsed.inMilliseconds} ');
  }

  FakeData? futureData;
  loadData() async {
    weatherstate.value = weatherDataState.loading;
    // await tz.initializeTimeZone();
    // var lagos = tz.getLocation('Africa/Lagos');
    // tz.setLocalLocation(lagos);
    // graphstate.value = dashboardGraphState.loading;

    // var stopwatch = Stopwatch()..start();
    // APIHandler pi = APIHandler();

    //fetch today's data
    print(DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day - 1, 0)
        .toString());
    await _handler
        .fetchDataHistory(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day - 1))
        .then((value) {
      allData.value = _handler.datahistory;
      _getGraphData();
    });

    //fetch weather data
    _handler.getDataOneCall(describeEnum(selectedLocation.value)).then((value) {
      weatherData.value = value;
    });
    _handler.getPrediction(describeEnum(selectedLocation)).then((value) {
      futureData = value;
      weatherstate.value = weatherDataState.success;
    });

    // graphdata = allData;

    // Stopwatch().stop();
    // print('loading data is done ${stopwatch.elapsed.inSeconds} ');

    // graphstate.value = dashboardGraphState.success;
    // _getGraphData();
  }

  // getLocalFakeData() {
  //   List<FakeData> data = [];

  //   for (var i = 0; i < 3; i++) {
  //     double temp = randomBetween(23, 25).toDouble();
  //     int pm = randomBetween(25, 28);
  //     int prssure = randomBetween(142, 145);
  //     int humidity = randomBetween(65, 75);
  //     int gas = randomBetween(1, 4);
  //     int ozone = randomBetween(5, 7);
  //     data.add(FakeData(
  //         temperature: temp.toString(),
  //         humidity: humidity.toString(),
  //         pm: pm.toString(),
  //         ozone: ozone.toString(),
  //         pressure: prssure.toString(),
  //         gas: gas.toString()));
  //   }
  //   fakedata.value = data;
  // }

  // loadData() async {
  //   print('Loadaing weather data');
  //   var stopwatch = Stopwatch()..start();
  //   APIHandler pi = APIHandler();
  //   weatherData.value = await pi.getDataOneCall();
  //   Stopwatch().stop();
  //   print('loading data is done ${stopwatch.elapsed.inSeconds} ');
  // }

  logout() {
    FirebaseAuth auth = FirebaseAuth.instance;

    // auth.signOut();
    auth.currentUser!.delete();
    GoogleSignIn().signOut();
    Get.offAll(() => main());
  }

  void handleItemSelected(DashMenuOptions value) {
    // if (value == DashMenuOptions.about) Get.to(AboutView());
    if (value == DashMenuOptions.logout) {
      logout();
    }
  }
}
