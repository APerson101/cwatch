import 'package:cwatch/app/appcontroller.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SettingsController extends GetxController {
  //if false, leave as it is, if true, change to something fanrenheit
  RxBool temperatureSetting = false.obs;

  RxString languageSetting = 'English'.obs;

  changeTemperature(bool newValue) {
    temperatureSetting.value = newValue;
    if (temperatureSetting.value) {
      //convert all temperature reading to fahrenheit
      AppController _mainC = Get.find();
      _mainC.temperatureUnit.value = true;
    }
  }
}
