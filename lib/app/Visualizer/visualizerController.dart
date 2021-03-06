import 'package:cwatch/apithings/APIHandler.dart';
import 'package:cwatch/app/Visualizer/defaultGraph.dart';
import 'package:cwatch/app/history/historyview.dart';
import 'package:cwatch/app/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pretty_json/pretty_json.dart';
import 'package:random_string/random_string.dart';

import 'visualizer.dart';

class VisualizerController extends GetxController {
  VisualizerController();
  APIHandler _handler = Get.find();
  @override
  void onInit() {
    loadData();

    super.onInit();
  }

  RxInt numberOfGraphs = 0.obs;

  RxInt numberPerRow = 1.obs;

  RxBool expandImage = false.obs;

  RxList<TestWidget> graphsWidgets = <TestWidget>[].obs;

  RxInt longpressegraph = 0.obs;
  RxMap<String, Map<String, List<FakeData>>> allData =
      <String, Map<String, List<FakeData>>>{}.obs;

  loadData() {
    // Map<String, Map<String, List<FakeData>>> alldata = {};
    // List<FakeData> fakedata = [];
    // Map<String, List<FakeData>> dayData = {};
    // for (var city = 0; city < 3; city++) {
    //   for (var day = 23; day < 28; day++) {
    //     for (var hour = 0; hour < 24; hour++) {
    //       var temp = randomBetween(23, 25).toDouble();
    //       fakedata.add(FakeData(
    //           temperature: temp.toString(),
    //           humidity: randomBetween(68, 70).toString(),
    //           pm: randomBetween(25, 27).toString(),
    //           ozone: randomBetween(5, 6).toString(),
    //           pressure: randomBetween(143, 160).toString(),
    //           time: DateTime(2021, 08, day, hour).toString(),
    //           gas: randomBetween(30, 40).toString()));
    //     }
    //     dayData.addAll({DateTime(2021, 08, day).toString(): fakedata});
    //     fakedata = [];
    //   }
    //   // printPrettyJson(dayData);

    //   alldata.addAll({describeEnum(cities.values[city]): dayData});
    //   dayData = {};
    // }
    // this.allData.value = alldata;
    _handler.loadHistory().then((_) => this.allData.value = _handler.alldata);
  }

  addGraph() {
    if (numberOfGraphs.value < 10)
      numberOfGraphs.value += 1;
    else
      return;
  }

  List<int> _deleted = [];
  deletegraph({required int index}) {
    graphsWidgets.removeWhere((element) => element.index.value == index);
    numberOfGraphs.value -= 1;
  }
}
