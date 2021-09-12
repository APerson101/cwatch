import 'package:cwatch/apithings/APIHandler.dart';
import 'package:cwatch/app/appcontroller.dart';
import 'package:cwatch/app/authenticationController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  RxString userName = 'inital'.obs;

  RxString password = 'initial'.obs;
  RxString loginstate = "loading".obs;
  AuthenticationController _controller = Get.find();

  login() async {
    //backend-
    loginstate.value = "loading";
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   Get.offNamed('/app');
    // });
    // GoogleAuthProvider googleProvider = GoogleAuthProvider();
    // GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    if (FirebaseAuth.instance.currentUser == null) {
      GoogleSignInAccount? acc = await GoogleSignIn().signIn();
      GoogleSignInAuthentication gauth = await acc!.authentication;
      var credential = GoogleAuthProvider.credential(
          accessToken: gauth.accessToken, idToken: gauth.idToken);
      // googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        _controller.loggedInUser.value = value.user;
        if (_controller.loggedInUser.value != null) {
          print('user signed in');
          // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          //   Get.offNamed('/app');
          // });
        }
      });
    } else {
      _controller.loggedInUser.value = FirebaseAuth.instance.currentUser;
      print(
          'user lredy sined in: ${FirebaseAuth.instance.currentUser!.displayName}');
    }
  }

  loginTest() {
    if (userName.value == "test456" && password.value == 'Pass1234') {
      print('user signed in');
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Get.offNamed('/app');
      });
    } else {
      Get.snackbar("error", "invalid login details");
    }
  }
}
