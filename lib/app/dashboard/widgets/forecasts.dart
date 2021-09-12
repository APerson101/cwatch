import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/history/historyview.dart';
import 'package:cwatch/app/models/weathermodel.dart';
import 'package:cwatch/app/responsive.dart';
import 'package:flutter/foundation.dart';
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
            Expanded(
                flex: 1,
                child: Text("Forecast",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            Expanded(flex: 5, child: getForecast()),
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
    Rx<CurrentandForecast> weatherData = controller.weatherData;
    FakeData? futureData = controller.futureData;

    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "Date: ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).toString().replaceRange(10, 23, "")}"),
            Obx(() {
              if (weatherData.value.current == null) return Container();
              String? forecast = "";
              forecast = weatherData.value.daily?.main!;

              return Text('Weather: $forecast');
            }),
            Obx(() {
              String? forecast = "";
              if (controller.weatherData.value.current == null)
                return Container();
              forecast = weatherData.value.daily?.description!;

              return Text('Description: $forecast');
            }),
            Text('Temperature (°C): ' + futureData!.temperature),
            Text('Atmospheric pressure ("Hg): ' + futureData.pressure),
            Text('Particulate matter 2.5: ' + futureData.pm),
            Text('Ozone (ppm): ' + futureData.ozone),
            Text('Humidity (%): ' + futureData.humidity),
          ]),
      // color: Colors.green,
    ).paddingDirectional(start: 4, end: 4, top: 4, bottom: 4);
  }
}
