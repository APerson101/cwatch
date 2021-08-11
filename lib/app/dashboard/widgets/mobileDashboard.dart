import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/dashboard/widgets/forecasts.dart';
import 'package:cwatch/app/responsive.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(child: InfoView(), color: Colors.red)
              .paddingOnly(
                  left: Insets.mGutter,
                  right: Insets.mGutter,
                  top: Insets.sm,
                  bottom: Insets.sm)
              .constrained(height: 70),
          Container(color: Colors.purple, child: LatestData())
              .paddingOnly(
                  left: Insets.mGutter,
                  right: Insets.mGutter,
                  top: Insets.sm,
                  bottom: Insets.sm)
              .constrained(height: 400),
          Container(
            color: Colors.deepPurple,
            child: ForeCastView(controller: this.controller),
          )
              .paddingOnly(
                  right: Insets.mGutter, top: Insets.sm, bottom: Insets.sm)
              .constrained(height: 150),
          Container(
                  child: GraphsView(controller: this.controller),
                  // child: Container(),
                  color: Colors.amber)
              .paddingOnly(
                  left: Insets.mGutter,
                  right: Insets.mGutter,
                  top: Insets.sm,
                  bottom: Insets.sm)
              .constrained(height: 400),
        ],
      ),
    ));
  }
}
