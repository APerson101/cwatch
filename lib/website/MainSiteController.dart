import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'mainsite.dart';

class MainSiteController extends GetxController {
  Rx<PageType> _currentPage = PageType.Home.obs;

  Rx<PageType> get currentPage => _currentPage;

  changePage(PageType newPage) {
    // index = newPage.index;
    _currentPage.value = newPage;
  }
}
