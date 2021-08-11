import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class LoginController extends GetxController {
  RxString userName = 'inital'.obs;

  RxString password = 'initial'.obs;

  login() {
    //backend
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Get.offNamed('/app');
    });
  }
}
