import 'package:cwatch/app/login/loginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {

    //   Get.offNamed('/app');
    // });
    return Material(
      child: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "enter username"),
              onChanged: (newValue) => controller.userName.value = newValue,
            ),
            TextFormField(
                onChanged: (newValue) => controller.password.value = newValue,
                decoration: InputDecoration(labelText: "enter password")),
            ElevatedButton(
                onPressed: () => controller.login(), child: Text('login'))
          ],
        ),
      )),
    );
  }
}
