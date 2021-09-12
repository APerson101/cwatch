import 'package:cwatch/apithings/APIHandler.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:random_string/random_string.dart';
import 'package:get/get.dart';

import 'historyview.dart';

enum historyLoadingStatus { loading, success, error, none }

class HistoryController extends GetxController {
  Rx<AllActiveLocations> currentLocation = AllActiveLocations.Abuja.obs;

  RxString selectedDate = DateTime.now().toString().obs;

  RxInt sortIndex = 0.obs;

  RxBool sortAscending = true.obs;
  Rx<historyLoadingStatus> currentStatus = historyLoadingStatus.none.obs;

  RxList<DayHistory> historyData = <DayHistory>[].obs;

  Rx<DateTime> userSelectedDate = DateTime.now().obs;
  APIHandler api = Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  loadData() async {
    currentStatus.value = historyLoadingStatus.loading;
    api
        .loadSpecificHistroy(
            location: currentLocation.value,
            date: userSelectedDate.value.microsecondsSinceEpoch)
        .then((value) {
      this.historyData.value = value;
      currentStatus.value = historyLoadingStatus.success;
    });
  }
}
