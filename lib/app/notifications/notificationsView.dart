import 'package:cwatch/app/notifications/notificationsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsView extends StatelessWidget {
  NotificationsView({Key? key}) : super(key: key);
  NotificationsController controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Notifications")));
  }
}
