import 'package:cwatch/app/settings/settingsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  SettingsView({Key? key}) : super(key: key);
  SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Settings",
              style: TextStyle(fontSize: 17),
            ),
            Row(
              children: [
                Text("temperature C"),
                Obx(() {
                  return Switch(
                      value: controller.temperatureSetting.value,
                      onChanged: (newvalue) =>
                          controller.temperatureSetting.value = newvalue);
                }),
                Text('F')
              ],
            ),
            ElevatedButton(onPressed: () {}, child: Text("theme")),
            Obx(() {
              return DropdownButton(
                  value: controller.languageSetting.value,
                  onChanged: (newval) {
                    print(newval);
                    controller.languageSetting.value = newval as String;
                  },
                  items: ["English", "French"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList());
            })
          ],
        ),
      )),
    );
  }
}
