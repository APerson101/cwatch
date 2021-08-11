import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/responsive.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';

class ForeCastView extends StatelessWidget {
  ForeCastView({Key? key, required this.controller}) : super(key: key);
  DashboardController controller;
  @override
  Widget build(BuildContext context) {
    return ObxValue((Rx<weatherDataState> data) {
      if (data.value == weatherDataState.loading)
        return Container(child: Center(child: CircularProgressIndicator()));
      if (data.value == weatherDataState.success)
        return Column(
          children: [
            Expanded(flex: 1, child: Text("Forecast")),
            Expanded(
                flex: 5,
                child:
                    Responsive.isMobile(context) || Responsive.isTablet(context)
                        ? Row(children: getForecast())
                        : Column(
                            children: getForecast(),
                          )),
          ],
        );
      return Container(
        child: Center(
          child: Text("Error"),
        ),
      );
    }, controller.weatherstate);
  }

  getForecast() {
    List<Widget> data = [];

    for (var i = 0; i < 3; i++) {
      data.add(Expanded(
        child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('STUFFS '),
                Obx(() {
                  var forecast = controller.weatherData.value.daily?.main;
                  return Text('$forecast');
                }),
                Obx(() {
                  var forecast =
                      controller.weatherData.value.daily?.description;
                  return Text('${forecast}');
                })
              ]),
          color: Colors.green,
        ).paddingDirectional(start: 4, end: 4, top: 4, bottom: 4),
      ));
    }
    return data;
  }
}
