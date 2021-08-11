import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:random_string/random_string.dart';

import 'historyview.dart';

enum historyLoadingStatus { loading, success, error }

class HistoryController extends GetxController {
  RxInt currentLocation = 0.obs;

  RxString selectedDate = DateTime.now().toString().obs;

  RxInt sortIndex = 0.obs;

  RxBool sortAscending = true.obs;
  Rx<historyLoadingStatus> currentStatus = historyLoadingStatus.loading.obs;

  RxList<FakeData> historyData = <FakeData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  _loadData() {
    currentStatus.value = historyLoadingStatus.loading;
    List<FakeData> things = [];
    //pm 27
    //temp 24C
    //humidity: 70%
    //ozone 5-5.3
    //pressure: 142

    for (var i = 0; i < 23; i++) {
      var temp = randomBetween(23, 25).toDouble();
      things.add(FakeData(
          temperature: temp.toString(),
          humidity: randomBetween(68, 70).toString(),
          pm: randomBetween(25, 27).toString(),
          ozone: randomBetween(5, 6).toString(),
          pressure: randomBetween(143, 160).toString(),
          time: '${randomBetween(0, 24)}:00',
          gas: randomBetween(30, 40).toString()));
    }

    historyData.value = things;
    currentStatus.value = historyLoadingStatus.success;
  }
}
