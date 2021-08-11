import 'dart:math';

import 'package:cwatch/apithings/APIHandler.dart';
import 'package:cwatch/app/history/historyview.dart';
import 'package:cwatch/app/models/dashboardgraphmodel.dart';
import 'package:cwatch/app/models/latestdatamodel.dart';
import 'package:cwatch/app/models/weathermodel.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:random_string/random_string.dart';

enum weatherDataState { loading, error, success }
enum dashboardGraphState { loading, error, success }

class DashboardController extends GetxController {
  RxInt currentgraphsSelection = 0.obs;
  Rx<CurrentandForecast> weatherData = CurrentandForecast().obs;
  Rx<weatherDataState> weatherstate = weatherDataState.loading.obs;
  RxList<FakeData> fakedata = <FakeData>[].obs;
  Rx<dashboardGraphState> graphstate = dashboardGraphState.loading.obs;
  RxBool graphradio = false.obs;
  RxList<DashboardGraphModel> graphdata = <DashboardGraphModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
    _getGraphData();
  }

  _getGraphData() {
    graphstate.value = dashboardGraphState.loading;
    List<DashboardGraphModel> data = [];
    Random rand = Random();
    print('creating fake data');
    var stopwatch = Stopwatch()..start();
    for (var i = 0; i < 23; i++) {
      int temp = randomBetween(23, 25);
      int pm = randomBetween(25, 28);
      int prssure = randomBetween(142, 145);
      int humidity = randomBetween(65, 75);
      int gas = randomBetween(1, 4);
      int ozone = randomBetween(5, 7);
      data.add(DashboardGraphModel(
          value: LatestDataModel(
              temperature: temp.toDouble(),
              pressure: prssure.toDouble(),
              pm: pm.toDouble(),
              ozone: ozone.toDouble(),
              gas: gas.toDouble(),
              humidity: humidity.toDouble()),
          time: DateTime(2017, 9, 7, 17, rand.nextInt(58)),
          source: 'temp'));
    }
    graphstate.value = dashboardGraphState.success;
    graphdata.value = data;
    Stopwatch().stop();
    print('creating fake data is done ${stopwatch.elapsed.inMilliseconds} ');
  }

  loadData() {
    print('Loadaing weather data');
    weatherstate.value = weatherDataState.loading;
    var stopwatch = Stopwatch()..start();
    APIHandler pi = APIHandler();
    // weatherData.value =
    pi.getDataOneCall().then((value) {
      weatherData.value = value;
    });
    Stopwatch().stop();
    print('loading data is done ${stopwatch.elapsed.inSeconds} ');
    List<FakeData> data = [];

    for (var i = 0; i < 3; i++) {
      double temp = randomBetween(23, 25).toDouble();
      int pm = randomBetween(25, 28);
      int prssure = randomBetween(142, 145);
      int humidity = randomBetween(65, 75);
      int gas = randomBetween(1, 4);
      int ozone = randomBetween(5, 7);
      data.add(FakeData(
          temperature: temp.toString(),
          humidity: humidity.toString(),
          pm: pm.toString(),
          ozone: ozone.toString(),
          pressure: prssure.toString(),
          gas: gas.toString()));
    }
    fakedata.value = data;
    weatherstate.value = weatherDataState.success;
  }

  // loadData() async {
  //   print('Loadaing weather data');
  //   var stopwatch = Stopwatch()..start();
  //   APIHandler pi = APIHandler();
  //   weatherData.value = await pi.getDataOneCall();
  //   Stopwatch().stop();
  //   print('loading data is done ${stopwatch.elapsed.inSeconds} ');
  // }

  logout() {}
}
