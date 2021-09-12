import 'package:cwatch/app/login/loginView.dart';
import 'package:cwatch/app/mainapp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/authenticationController.dart';
import 'pages.dart';
import 'package:huawei_push/huawei_push_library.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    getPages: GetPages().getPages(),
    initialRoute: '/',
  ));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AuthenticationController _authenticationController =
      Get.find<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    // return ObxValue<Rxn<User>>((val) {
    //   if (val.value == null) return LoginView();
    return MainApp();
    // }, _authenticationController.loggedInUser);

    // return _authenticationController.obx((state) {
    //   if (state == false) return Center(child: CircularProgressIndicator());
    //   if (state == true) {
    //     if (GetPlatform.isAndroid || GetPlatform.isIOS) {
    //       if (_authenticationController.loggedInUser.value == null) {
    //         print('phone not logged in');
    //         return LoginView();
    //         WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //           Get.offAllNamed('/login');
    //         });
    //       } else {
    //         print('phone, logged in');
    //         return MainApp();
    //         WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //           Get.offAllNamed('/app');
    //         });
    //       }
    //     }

    //     if (GetPlatform.isWeb) {
    //       WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //         Get.offAllNamed('/mainSite');
    //       });
    //     }
    //   }
    //   return Container();
    // });
  }
}
