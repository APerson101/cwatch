import 'package:cwatch/app/appcontroller.dart';
import 'package:cwatch/app/appsideMenu.dart';
import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/models/datamodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class InfoView extends StatelessWidget {
  InfoView({Key? key}) : super(key: key);
  final DashboardController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return getRadialGauge();
  }

  getRadialGauge() {
    return Obx(() {
      //get current hour's p
      List<LocationDataModel> data = controller.allData;
      if (data.isEmpty)
        return Center(child: CircularProgressIndicator.adaptive());

      int selected = data.indexWhere((element) =>
          element.location == describeEnum(controller.selectedLocation.value));
      String currentDateEpoch =
          DateTime(2021, DateTime.now().month, DateTime.now().day - 1)
              .microsecondsSinceEpoch
              .toString();
      String currentHour = DateTime(2021, DateTime.now().month,
              DateTime.now().day - 1, DateTime.now().hour)
          .microsecondsSinceEpoch
          .toString();
      LocationDataModel e = data[selected];

      double pm = double.parse(
          e.locationData[currentDateEpoch]!.dayData[currentHour]!.pm);
      return Container(
          child: SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 4500,
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 300,
            annotations: [
              GaugeAnnotation(
                  angle: 90,
                  positionFactor: 0.3,
                  widget: Container(child: Text("p.m 2.5"))),
              GaugeAnnotation(
                  angle: 90,
                  positionFactor: 0.9,
                  widget: Container(child: Text("$pm")))
            ],
            pointers: [NeedlePointer(value: pm)],
            ranges: [
              GaugeRange(startValue: 0, endValue: 50, color: Colors.green),
              GaugeRange(startValue: 51, endValue: 100, color: Colors.yellow),
              GaugeRange(startValue: 101, endValue: 150, color: Colors.orange),
              GaugeRange(startValue: 151, endValue: 200, color: Colors.red),
              GaugeRange(startValue: 201, endValue: 300, color: Colors.purple),
            ],
          )
        ],
      ));
    });
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
