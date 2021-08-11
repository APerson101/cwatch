import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles.dart';
import 'widgets/mobileDashboard.dart';
import 'widgets/webDashboard.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());
  DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pad = EdgeInsets.only(
        left: Insets.mGutter,
        right: Insets.mGutter,
        top: Insets.sm,
        bottom: Insets.sm);
    return Responsive.isMobile(context) ? MobileDashboard() : WebDashboard();
  }
}
