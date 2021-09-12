import 'package:cwatch/apithings/APIHandler.dart';
import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/dashboard/widgets/forecasts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:get/get.dart';

import '../../config.dart';
import 'DashboardgraphsView.dart';
import 'importantInfo.dart';
import 'latestData.dart';

class WebDashboard extends StatelessWidget {
  WebDashboard({Key? key}) : super(key: key);
  DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              child: Row(children: [
                Expanded(child: Container()),
                Text(
                    "Welcome to Cwatch! The only Climate Monitoring platform in West Africa",
                    style: TextStyle(
                        letterSpacing: 2,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Expanded(child: Container()),
                Row(children: [
                  Text("Location: ", style: TextStyle(letterSpacing: 1.7)),
                  Obx(() => DropdownButton<AllActiveLocations>(
                      onChanged: (newLocation) =>
                          controller.changeLocation(newLocation!),
                      value: controller.selectedLocation.value,
                      underline: Container(),
                      items: AllActiveLocations.values
                          .map((e) => DropdownMenuItem<AllActiveLocations>(
                              value: e, child: Text(describeEnum(e))))
                          .toList()))
                ])
              ]),
            )
                .decorated(
                    color: Get.theme.highlightColor,
                    borderRadius: BorderRadius.circular(20))
                .padding(
                    left: Insets.mGutter,
                    right: Insets.mGutter,
                    top: Insets.sm,
                    bottom: Insets.sm)),
        Expanded(
            flex: 3,
            child: Row(children: [
              Expanded(
                  child: Container(
                child: Stack(children: [
                  InfoView(),
                  IconButton(
                          onPressed: () => showInfo("PM"),
                          icon: Icon(Icons.info))
                      .positioned(right: 0, top: 0)
                ]),
              )
                      .decorated(
                          color: Get.theme.highlightColor,
                          borderRadius: BorderRadius.circular(20))
                      .padding(
                          left: Insets.mGutter,
                          right: Insets.mGutter,
                          top: Insets.sm,
                          bottom: Insets.sm)),
              Expanded(
                  child: Container(
                          child: Stack(children: [
                LatestData(),
                IconButton(
                        onPressed: () => showInfo("latest"),
                        icon: Icon(Icons.info))
                    .positioned(right: 0, top: 0)
              ]))
                      .decorated(
                          color: Get.theme.highlightColor,
                          borderRadius: BorderRadius.circular(20))
                      .padding(
                          left: Insets.mGutter,
                          right: Insets.mGutter,
                          top: Insets.sm,
                          bottom: Insets.sm)),
            ])),
        Expanded(
            flex: 4,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: Stack(children: [
                          GraphsView(controller: this.controller),
                          IconButton(
                                  onPressed: () => showInfo("graph"),
                                  icon: Icon(Icons.info))
                              .positioned(right: 0, top: 0)
                        ]),
                      )
                          .decorated(
                              color: Get.theme.highlightColor,
                              borderRadius: BorderRadius.circular(20))
                          .padding(
                              left: Insets.mGutter,
                              right: Insets.mGutter,
                              top: Insets.sm,
                              bottom: Insets.sm)),
                  Expanded(
                      flex: 1,
                      child: Container(
                              child: Stack(children: [
                        ForeCastView(controller: this.controller),
                        IconButton(
                                onPressed: () => showInfo("forecast"),
                                icon: Icon(Icons.info))
                            .positioned(right: 0, top: 0)
                      ]))
                          .decorated(
                              color: Get.theme.highlightColor,
                              borderRadius: BorderRadius.circular(20))
                          .padding(
                              left: Insets.mGutter,
                              right: Insets.mGutter,
                              top: Insets.sm,
                              bottom: Insets.sm))
                ],
              ),
            ))
      ],
    ));
  }

  showInfo(String type) {
    String description = "";
    switch (type) {
      case "graph":
        description =
            "This shows the graph of the latest data throughout the day at the selected location";
        break;
      case "forecast":
        description = "This shows the forecase of the next day's data";
        break;
      case "latest":
        description =
            "This shows the latest data at the selected location which updates every hour";
        break;
      case "PM":
        description =
            "This is a representation of the Pm 2.5 and the severity level";
        break;
      default:
    }
    Get.defaultDialog(
      title: "$type description",
      content: Container(child: Center(child: Text(description)))
          .width(200)
          .height(150),
    );
  }
}
