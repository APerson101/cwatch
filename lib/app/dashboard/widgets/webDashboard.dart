import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/dashboard/widgets/forecasts.dart';
import 'package:flutter/material.dart';
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
            child: Container(child: InfoView(), color: Colors.red).paddingOnly(
                left: Insets.mGutter,
                right: Insets.mGutter,
                top: Insets.sm,
                bottom: Insets.sm)),
        Expanded(
            flex: 2,
            child: Container(color: Colors.purple, child: LatestData())
                .paddingOnly(
                    left: Insets.mGutter,
                    right: Insets.mGutter,
                    top: Insets.sm,
                    bottom: Insets.sm)),
        Expanded(
            flex: 3,
            child: Container(
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                              child: GraphsView(controller: this.controller),
                              // child: Container(),
                              color: Colors.amber)
                          .paddingOnly(
                              left: Insets.mGutter,
                              right: Insets.mGutter,
                              top: Insets.sm,
                              bottom: Insets.sm)),
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.deepPurple,
                        child: ForeCastView(controller: this.controller),
                      ).paddingOnly(
                          right: Insets.mGutter,
                          top: Insets.sm,
                          bottom: Insets.sm))
                ],
              ),
            ))
      ],
    ));
  }
}
