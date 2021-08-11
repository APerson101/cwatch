import 'package:cwatch/app/appcontroller.dart';
import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/history/historyview.dart';
import 'package:cwatch/app/models/latestdatamodel.dart';
import 'package:cwatch/app/models/weathermodel.dart';
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
          List<FakeData> data = controller.fakedata;
          // print('loading data again ohhh');
          return Container(
            child: Column(children: [
              Expanded(flex: 1, child: Text("Latest Data")),
              Expanded(flex: 5, child: Row(children: getData(data: data)))
            ]),
          );
        });
      return Container(child: Center(child: Text("error")));
    }, controller.weatherstate);
  }

  getData({required List<FakeData> data}) {
    return data
        .map(
          (e) => Expanded(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Abuja: ', style: TextStyle(fontSize: 23)),
                Text('Temperature: ' + e.temperature.toString()),
                Text('Atmospheric pressure: ' + e.pressure.toString()),
                Text('Particulate matter 2.5: ' + e.pm.toString()),
                Text('Ozone: ' + e.ozone.toString()),
                Text('Gas: ' + e.gas.toString()),
                Text('humidity: ' + e.humidity.toString()),
                Obx(() {
                  var currentdata =
                      controller.weatherData.value.current?.weather?.main;
                  // WeatherModel? weather = currentdata.value.current;
                  // if(weather?.weather?.main!=null)
                  return Text('weather: $currentdata');
                  // else return Text()
                }),
                Obx(() {
                  var currentdata = controller
                      .weatherData.value.current?.weather?.description;

                  return Text('desc: $currentdata');
                })
              ],
            ),
            color: Colors.red,
          ).paddingDirectional(start: 4, end: 4, top: 4, bottom: 4)),
        )
        .toList();
  }
}
