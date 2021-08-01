import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/authenticationController.dart';
import 'pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
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
    return _authenticationController.obx((state) {
      if (state == false) return Center(child: CircularProgressIndicator());
      if (state == true) {
        if (GetPlatform.isAndroid || GetPlatform.isIOS) {
          if (_authenticationController.loggedInUser.value == null) {
            print('phone, not logged in');
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              Get.offAllNamed('/app');
            });
          } else {
            print('phone not logged in');
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              Get.offAllNamed('/login');
            });
          }
        }

        if (GetPlatform.isWeb) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            Get.offAllNamed('/mainSite');
          });
        }
      }
      return Container();
    });
  }
}
