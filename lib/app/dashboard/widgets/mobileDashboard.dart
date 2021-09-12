import 'package:cwatch/apithings/APIHandler.dart';
import 'package:cwatch/app/appcontroller.dart';
import 'package:cwatch/app/authenticationController.dart';
import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/dashboard/widgets/forecasts.dart';
import 'package:cwatch/app/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:get/get.dart';

import '../../config.dart';
import 'DashboardgraphsView.dart';
import 'importantInfo.dart';
import 'latestData.dart';

class MobileDashboard extends StatelessWidget {
  MobileDashboard({Key? key}) : super(key: key);
  final DashboardController controller = Get.find();
  final AuthenticationController _appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: locationSelector(),
              // color: Colors.green,
            ).constrained(height: 70),
            Container(child: InfoView())
                .paddingOnly(
                    left: Insets.mGutter,
                    right: Insets.mGutter,
                    top: Insets.sm,
                    bottom: Insets.sm)
                .constrained(height: 200),
            Container(child: LatestData())
                .paddingOnly(
                    left: Insets.mGutter,
                    right: Insets.mGutter,
                    top: Insets.sm,
                    bottom: Insets.sm)
                .constrained(height: 400),
            Container(
              // color: Colors.deepPurple,
              child: ForeCastView(controller: this.controller),
            )
                .paddingOnly(
                    right: Insets.mGutter, top: Insets.sm, bottom: Insets.sm)
                .constrained(height: 500),
            Container(
              child: GraphsView(controller: this.controller),
              // child: Container(),
            )
                .paddingOnly(
                    left: Insets.mGutter,
                    right: Insets.mGutter,
                    top: Insets.sm,
                    bottom: Insets.sm)
                .constrained(height: 400),
          ],
        ),
      )),
    );
  }

  locationSelector() {
    return Container(
        child: Row(
      children: [
        PopupMenuButton<DashMenuOptions>(onSelected: (value) {
          controller.handleItemSelected(value);
        }, itemBuilder: (BuildContext context) {
          return DashMenuOptions.values
              .map((e) => PopupMenuItem<DashMenuOptions>(
                  value: e, child: Text(describeEnum(e))))
              .toList();
        }),
        Expanded(
            child: Container(
                child: Center(
                    child: Text(
          _appController.loggedInUser.value != null
              ? "Welcome: ${_appController.loggedInUser.value!.displayName}"
              : "Welcome to Cwatch",
          // "Welcome: Francis ",
          style: TextStyle(fontWeight: FontWeight.w200, fontSize: 18),
        )))),
        Obx(() => DropdownButton<AllActiveLocations>(
            onChanged: (newLocation) => controller.changeLocation(newLocation!),
            value: controller.selectedLocation.value,
            underline: Container(),
            items: AllActiveLocations.values
                .map((e) => DropdownMenuItem<AllActiveLocations>(
                    value: e, child: Text(describeEnum(e))))
                .toList()))
      ],
    ));
  }
}
