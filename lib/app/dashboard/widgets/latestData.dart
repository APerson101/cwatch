import 'package:cwatch/apithings/APIHandler.dart';
import 'package:cwatch/app/appcontroller.dart';
import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/history/historyview.dart';
import 'package:cwatch/app/models/datamodel.dart';
import 'package:cwatch/app/models/latestdatamodel.dart';
import 'package:cwatch/app/models/weathermodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:styled_widget/styled_widget.dart';

class LatestData extends StatelessWidget {
  LatestData({Key? key}) : super(key: key);
  DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return ObxValue((Rx<weatherDataState> data) {
      if (data.value == weatherDataState.loading)
        return Container(child: Center(child: CircularProgressIndicator()));
      if (data.value == weatherDataState.success)
        return Obx(() {
          List<LocationDataModel> data = controller.allData;
          return Container(
            child: Column(children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    "Latest Data",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 3),
                  )),
              Expanded(
                  flex: 5,
                  child: data.isEmpty
                      ? Container(
                          child: Center(
                              child: CircularProgressIndicator.adaptive()))
                      : getData(data: data))
            ]),
          );
        });
      return Container(child: Center(child: Text("error")));
    }, controller.weatherstate);
  }

  getData({required List<LocationDataModel> data}) {
    return latestData(data);
  }

  latestData(List<LocationDataModel> data) {
    return Obx(() {
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
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Temperature (°C): ' +
                    e.locationData[currentDateEpoch]!.dayData[currentHour]!
                        .temperature,
                style: TextStyle(letterSpacing: 3)),
            Text(
                'Atmospheric pressure ("Hg): ' +
                    e.locationData[currentDateEpoch]!.dayData[currentHour]!
                        .pressure,
                style: TextStyle(letterSpacing: 3)),
            Text(
                'Particulate matter 2.5: ' +
                    e.locationData[currentDateEpoch]!.dayData[currentHour]!.pm,
                style: TextStyle(letterSpacing: 3)),
            Text(
                'Ozone (ppm): ' +
                    e.locationData[currentDateEpoch]!.dayData[currentHour]!
                        .ozone,
                style: TextStyle(letterSpacing: 3)),
            Text(
                'Humidity (%): ' +
                    e.locationData[currentDateEpoch]!.dayData[currentHour]!
                        .humidity,
                style: TextStyle(letterSpacing: 3)),
            Obx(() {
              String? currentdata = "";
              if (controller.weatherData.value.current == null)
                return CircularProgressIndicator.adaptive();
              currentdata =
                  controller.weatherData.value.current?.weather?.main!;

              // controller.weatherData.value.current?.weather?.main;
              // WeatherModel? weather = currentdata.value.current;
              // if(weather?.weather?.main!=null)
              return Text('Weather: $currentdata',
                  style: TextStyle(letterSpacing: 3));
              // else return Text()
            }),
            Obx(() {
              String? currentdata = "";
              if (controller.weatherData.value.current == null)
                return Container();
              currentdata =
                  controller.weatherData.value.current?.weather?.description!;

              return Text('Description: $currentdata',
                  style: TextStyle(letterSpacing: 3));
            })
          ],
        ),
        // color: Colors.red,
      ).paddingDirectional(start: 4, end: 4, top: 4, bottom: 4);
    });
  }
}
