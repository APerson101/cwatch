import 'package:cwatch/app/appcontroller.dart';
import 'package:cwatch/app/appsideMenu.dart';
import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoView extends StatelessWidget {
  InfoView({Key? key}) : super(key: key);
  final DashboardController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(flex: 1, child: Text("important information")),
          Expanded(
              flex: 6,
              child: Container(
                  child: DropdownButton(
                      items: userinfo(),
                      onChanged: (newv) {
                        AppController _appController = Get.find();

                        if (newv == menudrop.logout.index) {
                          _appController.logOut();
                        } else if (newv == menudrop.apikey.index) {
                          _appController.changePage(AppPages.API);
                        }
                      },
                      icon: Icon(Icons.person),
                      hint: Text("Abdulhadi hashim")),
                  color: Colors.purpleAccent)),
        ],
      ),
    );
  }

  userinfo() {
    return menudrop.values
        .map((e) => DropdownMenuItem(
              child: Text(describeEnum(e)),
              value: e.index,
            ))
        .toList();
  }
}

enum menudrop { logout, apikey }
