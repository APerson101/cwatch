import 'package:cwatch/app/Profile/profileController.dart';
import 'package:cwatch/app/about/aboutView.dart';
import 'package:cwatch/app/apikey/apikey.dart';
import 'package:cwatch/app/appcontroller.dart';
import 'package:cwatch/app/responsive.dart';
import 'package:cwatch/app/settings/settingsView.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MenuOptions { settings, about, logout, API }

class ProfileView extends StatelessWidget {
  ProfileView({Key? key}) : super(key: key);
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Responsive.isMobile(context)
            ? AppBar(
                title: Expanded(child: Text("profile")),
                actions: [
                  PopupMenuButton<int>(onSelected: (value) {
                    if (value == MenuOptions.settings.index)
                      Get.to(SettingsView());
                    else if (value == MenuOptions.about.index)
                      Get.to(AboutView());
                    if (value == MenuOptions.logout.index) {
                      AppController _controller = Get.find();
                      _controller.logOut();
                    }
                    if (value == MenuOptions.API.index) Get.to(Apikey());
                  }, itemBuilder: (BuildContext context) {
                    return MenuOptions.values
                        .map((e) => PopupMenuItem<int>(
                            value: e.index, child: Text(describeEnum(e))))
                        .toList();
                  })
                ],
              )
            : null,
        body: Center(child: Text("Profile")));
  }
}
