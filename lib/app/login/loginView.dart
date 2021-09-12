import 'package:cwatch/app/login/loginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {

    //   Get.offNamed('/app');
    // });
    return Material(
        child: SafeArea(
      child: Container(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Hello !",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ).paddingOnly(bottom: 17),
                  Text("Welcome to Cwatch! The best climate platform in Africa",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))
                      .paddingOnly(bottom: 25),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                              gapPadding: 20,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                          labelText: "Enter username"),
                      onChanged: (newValue) =>
                          controller.userName.value = newValue,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 15),
                      child: TextFormField(
                          onChanged: (newValue) =>
                              controller.password.value = newValue,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              border: OutlineInputBorder(
                                  gapPadding: 20,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              labelText: "Enter password"))),
                  Row(children: [
                    Expanded(child: Container()),
                    TextButton(
                            onPressed: () {},
                            child: Text("forgotten password?"))
                        .paddingOnly(bottom: 20)
                  ]),
                  SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () => controller.loginTest(),
                              child: Text('login')))
                      .paddingOnly(bottom: 30),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                          padding: EdgeInsets.only(left: 7, right: 7),
                          child: Text("or login with")),
                      Expanded(child: Divider())
                    ],
                  ).paddingOnly(bottom: 20),
                  SizedBox(
                    width: double.infinity,
                    child: SignInButton(
                      Buttons.GoogleDark,
                      onPressed: () => controller.login(),
                    ),
                  )
                ],
              ),
            )),
      ),
    ));
  }
}
