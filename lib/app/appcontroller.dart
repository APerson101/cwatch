import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'appsideMenu.dart';

class AppController extends GetxController {
  Rx<AppPages> _currentPage = AppPages.Dashboard.obs;

  User? user;

  Rx<AppPages> get currentPage => _currentPage;
  RxBool temperatureUnit = false.obs;

  changePage(AppPages newPage) {
    _currentPage.value = newPage;
  }

  void logOut() {
    if (GetPlatform.isAndroid || GetPlatform.isIOS) Get.offAllNamed('/login');
    if (GetPlatform.isWeb) Get.offAllNamed('/');
  }
}
