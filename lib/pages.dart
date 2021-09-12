import 'package:cwatch/apithings/APIHandler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'app/appcontroller.dart';
import 'app/authenticationController.dart';
import 'app/login/loginController.dart';
import 'app/login/loginView.dart';
import 'app/mainapp.dart';
import 'main.dart';
import 'website/MainSiteController.dart';
import 'website/mainsite.dart';

class GetPages {
  List<GetPage<dynamic>> getPages() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return [
      GetPage(name: '/', page: () => MyApp(), bindings: [
        BindingsBuilder(() =>
            Get.lazyPut(() => AuthenticationController(auth), fenix: true)),
        BindingsBuilder(() => Get.lazyPut(() => AppController(), fenix: true)),
        BindingsBuilder(() => Get.lazyPut(() => APIHandler(), fenix: true)),
      ]),
      GetPage(name: '/mainSite', page: () => MainSite(), bindings: [
        BindingsBuilder(() => Get.lazyPut(() => MainSiteController())),
      ]),
      GetPage(name: '/app', page: () => MainApp(), bindings: [
        BindingsBuilder(() => Get.lazyPut(() => AppController(), fenix: true)),
      ]),
      GetPage(
        name: '/login',
        page: () => LoginView(),
        bindings: [
          BindingsBuilder(() => Get.lazyPut(() => APIHandler(), fenix: true)),
          BindingsBuilder(() => Get.lazyPut(() => LoginController()))
        ],
      ),
    ];
  }
}
