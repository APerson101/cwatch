import 'package:cwatch/app/dashboard/dashboardController.dart';
import 'package:cwatch/app/models/dashboardgraphmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../appcontroller.dart';

enum AllDashboardGraphSelections {
  all,
  temperature,
  pressure,
  humidity,
  gas,
  ozone,
  pm
}

class GraphsView extends StatelessWidget {
  GraphsView({Key? key, required this.controller}) : super(key: key);
  DashboardController controller;
  @override
  Widget build(BuildContext context) {
    return ObxValue((Rx<dashboardGraphState> state) {
      if (state.value == dashboardGraphState.loading)
        return CircularProgressIndicator();
      if (state.value == dashboardGraphState.success)
        return Obx(() {
          var data = controller.graphdata;
          return graphcontent(data: data);
        });

      return Container(child: Center(child: Text("Error")));
    }, controller.graphstate);
  }

  Container graphcontent({required RxList<DashboardGraphModel> data}) {
    return Container(
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(child: Text("graphs")),
                  Expanded(child: Obx(
                    () {
                      return DropdownButton(
                        value: controller.currentgraphsSelection.value,
                        items: graphSelectionDropDown(),
                        onChanged: (int? newValue) {
                          print(newValue);
                          controller.currentgraphsSelection.value = newValue!;
                        },
                      );
                    },
                  )),
                  Expanded(
                      child: Row(
                    children: [
                      Text("show gridlines"),
                      Obx(() {
                        return Switch(
                            value: controller.graphradio.value,
                            onChanged: (newValue) =>
                                controller.graphradio.value = newValue);
                      }),
                    ],
                  ))
                ],
              )),
          Expanded(
              flex: 5, child: Container(child: dashboardGraph(data: data))),
        ],
      ),
    );
  }

  graphSelectionDropDown() {
    return AllDashboardGraphSelections.values
        .map((e) =>
            DropdownMenuItem(value: e.index, child: Text(describeEnum(e))))
        .toList();
  }

  dashboardGraph({required data}) {
    // return Obx(
    //   () {
    return Center(
      child: Container(
          child: SfCartesianChart(
              legend: Legend(
                  isVisible: controller.currentgraphsSelection.value == 0
                      ? true
                      : false,
                  isResponsive: true),
              title: getGraphTitle(controller.currentgraphsSelection),
              tooltipBehavior: TooltipBehavior(enable: true),
              // enableAxisAnimation: true,
              primaryXAxis: DateTimeCategoryAxis(
                // autoScrollingDelta: 7,
                majorGridLines: MajorGridLines(
                    width: controller.graphradio.value ? 0.7 : 0),
                // autoScrollingMode: AutoScrollingMode.start,
                title: AxisTitle(text: 'Time'),
                // autoScrollingDeltaType: DateTimeIntervalType.hours
              ),
              primaryYAxis: NumericAxis(
                  majorGridLines: MajorGridLines(
                      width: controller.graphradio.value ? 0.7 : 0),
                  title: AxisTitle(
                      text: getYTitle(controller.currentgraphsSelection))),
              series:
                  getSeries(controller.currentgraphsSelection, data: data))),
    );
    //   },
    // );
  }

  getGraphTitle(RxInt current) {
    switch (current.value) {
      //all
      case 0:
        return ChartTitle(text: 'Graph of all data for today');
      case 1:
        return ChartTitle(text: 'Graph of temperature data for today');

      case 2:
        return ChartTitle(text: 'Graph of pressure data for today');

      case 3:
        return ChartTitle(text: 'Graph of humidity data for today');
      case 4:
        return ChartTitle(text: 'Graph of gas data for today');
      case 5:
        return ChartTitle(text: 'Graph of ozone data for today');
      case 6:
        return ChartTitle(text: 'Graph of PM data for today');
      default:
        return ChartTitle(text: '');
    }
  }

  getYTitle(RxInt current) {
    switch (current.value) {
      //all
      case 0:
        return 'all data today';
      case 1:
        return 'temperature';

      case 2:
        return 'pressure';

      case 3:
        return 'Humidity';
      case 4:
        return 'Gas';
      case 5:
        return 'Ozone';
      case 6:
        return 'PM 2.5';
      default:
        return '';
    }
  }

  getSeries(RxInt currentlySelected, {required data}) {
    String xtitle = "Time";
    switch (currentlySelected.value) {
      //all
      case 0:
        return [
          //SplineSeries vs FastLineSeries
          SplineSeries<DashboardGraphModel, DateTime>(
              xAxisName: xtitle,
              name: 'temperature',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) {
                // if (fah)
                //   return (value.value.temperature * (9 / 5)) + 32;
                // else
                return (value.value.temperature);
              },
              color: Colors.red),
          SplineSeries<DashboardGraphModel, DateTime>(
              xAxisName: xtitle,
              name: 'pressure',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) =>
                  value.value.pressure,
              color: Colors.blue),
          SplineSeries<DashboardGraphModel, DateTime>(
              xAxisName: xtitle,
              name: 'pm 2.5',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) => value.value.pm,
              color: Colors.green),
          SplineSeries<DashboardGraphModel, DateTime>(
              xAxisName: xtitle,
              name: 'gas',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) => value.value.gas,
              color: Colors.orange),
          SplineSeries<DashboardGraphModel, DateTime>(
              xAxisName: xtitle,
              name: 'humidity',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) =>
                  value.value.humidity,
              color: Colors.pink),
          SplineSeries<DashboardGraphModel, DateTime>(
              xAxisName: xtitle,
              name: 'ozone',
              yAxisName: 'All Data',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) => value.value.ozone,
              color: Colors.purple),
        ];
      case 1:
        return [
          SplineSeries<DashboardGraphModel, DateTime>(
              width: 7,
              // animationDuration: 1000,
              name: 'Temperature',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) {
                // if (fah)
                //   return (value.value.temperature * (9 / 5)) + 32;
                // else
                return (value.value.temperature);
              },
              color: Colors.red),
        ];
      case 2:
        return [
          SplineSeries<DashboardGraphModel, DateTime>(
              xAxisName: xtitle,
              name: 'Atmospheric Pressure',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) =>
                  value.value.pressure,
              color: Colors.blue),
        ];
      case 3:
        return [
          SplineSeries<DashboardGraphModel, DateTime>(
              xAxisName: xtitle,
              name: 'Humidity',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) =>
                  value.value.humidity,
              color: Colors.pink),
        ];
      case 4:
        return [
          SplineSeries<DashboardGraphModel, DateTime>(
              name: 'Gas',
              xAxisName: xtitle,
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) => value.value.gas,
              color: Colors.orange),
        ];
      case 5:
        return [
          SplineSeries<DashboardGraphModel, DateTime>(
              xAxisName: xtitle,
              name: 'Ozone',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) => value.value.ozone,
              color: Colors.purple),
        ];
      case 6:
        return [
          SplineSeries<DashboardGraphModel, DateTime>(
              xAxisName: xtitle,
              name: 'PM',
              dataSource: data,
              xValueMapper: (DashboardGraphModel time, _) => time.time,
              yValueMapper: (DashboardGraphModel value, _) => value.value.pm,
              color: Colors.green),
        ];
      default:
        return [];
    }
  }
}
