import 'package:filter_list/filter_list.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:cwatch/app/Visualizer/visualizerController.dart';
import 'package:cwatch/app/history/historyview.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';

import 'defaultgraphcontroller.dart';

enum possiblePlots {
  sparkLineChart,
  sparkAreaChart,
  sparkbarChart,
  sparkWinLossChart,
  TreeMap,
  HeatMap,
  funnelChart,
  pyramidChart,
  circularpiChart,
  CircularDoughnutChart,
  CircularRadialBarChart,
  cartesianChart,
  FastLineChart,
  AreaChart,
  SplineChart,
  ColumnChart,
  BarChart,
  BubbleChart,
  ScatterChart,
  SteplineChart,
  RangecolumnChart,
  RangeareaChart,
  SplineareaChart,
  SplinerangeareaChart,
  StepareaChart,
  HistogramChart,
  StackedlineChart,
  StackedareaChart,
  StackedcolumnChart,
  StackedbarChart,
  Stackedarea100Chart,
  Stackedcolumn100Chart,
  Stackedbar100Chart,
  Stackedline100Chart,
  HiLoChart,
  OHLCChart,
  CandleChart,
  BoxandWhiskerChart,
  WaterfallChart
}
enum graphs {
  lineChart,
  AreaChart,
  Column,
  Bubble,
  Scatter,
  StepLine,
  StepareaChart,
  HistogramChart,
  StackedlineChart,
  StackedareaChart,
  StackedcolumnChart,
  BoxandWhiskerChart,
  // TreeMap,
  pyramidChart,
  circularpieChart,
  CircularDoughnutChart,
  CircularRadialBarChart,
}

class DefaultGraph extends StatelessWidget {
  RxBool showgraphAxis = true.obs;

  RxBool showlegend = true.obs;

  RxBool showtitle = true.obs;

  RxBool showXName = true.obs;

  RxBool showYName = true.obs;
  RxBool singleDatePicker = true.obs;

  Rx<xAxis> selectedXPlot = xAxis.hr.obs;
  Rx<yAxisAverage> selectedyAxisAvg = yAxisAverage.AverageTemp.obs;
  Rx<yAxisSingle> selectedyAxisSingle = yAxisSingle.Temperature.obs;

  RxBool selectgraph = false.obs;

  RxInt selectedCity = 0.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<Color> plotAreaBackgroundColor = Colors.red.obs;

  // RxInt selectedGraph = 0.obs;
  Rx<graphs> selectedGraph = graphs.lineChart.obs;
  DefaultGraph({Key? key}) : super(key: key);
  VisualizerController Visualcontroller = Get.find();
  // DefaultGraphController controller = Get.put(DefaultGraphController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (selectgraph.value) return _graph(context);

      return Container(
        child: Center(
            child: ElevatedButton(
                // onPressed: () => selectgraph.value = true,
                onPressed: () {
                  Get.defaultDialog(
                      title: "Make Selections",
                      content: showSettingsPopUp(context),
                      onConfirm: () {
                        selectgraph.value = true;
                        Get.back();
                      },
                      onCancel: () => Get.back());
                },
                child: Text('select graph'))),
      );
    });
  }

  Widget _graph(BuildContext context) {
    List<Map<String, List<FakeData>>> rawdata = [];

    selectedCities.forEach((city) {
      rawdata.add(Visualcontroller.allData[city]!);
    });
    // return
    List<List<FakeData>> graphData = datacleaning(rawdata);
    Widget child = Container();
    if (selectedGraph.value == graphs.CircularDoughnutChart ||
        selectedGraph.value == graphs.CircularRadialBarChart ||
        selectedGraph.value == graphs.circularpieChart) {
      child = SfCircularChart(
          legend: Legend(isResponsive: true, isVisible: showlegend.value),
          title: showtitle.value ? ChartTitle(text: "Default title") : null,
          // primaryXAxis: CategoryAxis(),

          series: _getSeries(graphData));
    } else if (selectedGraph.value == graphs.pyramidChart) {
      child = SfPyramidChart(
        legend: Legend(isResponsive: true, isVisible: showlegend.value),
        title: showtitle.value ? ChartTitle(text: "Default title") : null,
        series: _getSeries(graphData),
      );
    } else {
      child = SfCartesianChart(
          plotAreaBackgroundColor: plotAreaBackgroundColor.value,
          tooltipBehavior: TooltipBehavior(enable: true),
          crosshairBehavior: CrosshairBehavior(enable: true),
          legend: Legend(isResponsive: true, isVisible: showlegend.value),
          title: showtitle.value ? ChartTitle(text: "Default title") : null,
          // plotAreaBorderWidth: 0.0,
          primaryXAxis: selectedXPlot.value == xAxis.locations
              ? CategoryAxis(
                  title: showXName.value
                      ? AxisTitle(text: "default x axis")
                      : null,
                  majorGridLines:
                      MajorGridLines(width: showgraphAxis.value ? 0.7 : 0),
                )
              : DateTimeAxis(
                  intervalType: singleDatePicker.value ||
                          (!singleDatePicker.value &&
                              selectedXPlot.value == xAxis.hr)
                      ? DateTimeIntervalType.hours
                      : DateTimeIntervalType.days,
                  majorGridLines:
                      MajorGridLines(width: showgraphAxis.value ? 0.7 : 0),
                  title: showXName.value
                      ? AxisTitle(text: "default x axis")
                      : null),
          primaryYAxis: NumericAxis(
              majorGridLines:
                  MajorGridLines(width: showgraphAxis.value ? 0.7 : 0),
              title:
                  showYName.value ? AxisTitle(text: "default y axis") : null),
          series: _getSeries(graphData));
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Container()),
            IconButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: "Settings",
                    content: graphSettings(context),
                  );
                },
                icon: Icon(Icons.settings))
          ],
        ),
        Flexible(child: child)
      ],
    );
  }

  _tril(city, selected) {
    switch (selectedGraph.value) {
      case graphs.lineChart:
        return FastLineSeries<FakeData, DateTime>(
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.AreaChart:
        return AreaSeries<FakeData, DateTime>(
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.Bubble:
        return BubbleSeries<FakeData, DateTime>(
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.Column:
        return ColumnSeries<FakeData, DateTime>(
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.Scatter:
        return ScatterSeries<FakeData, DateTime>(
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.StepLine:
        return StepLineSeries<FakeData, DateTime>(
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.StepareaChart:
        return StepAreaSeries<FakeData, DateTime>(
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.HistogramChart:
        return HistogramSeries<FakeData, DateTime>(
            dataSource: city,
            yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
            showNormalDistributionCurve: true);

      case graphs.StackedlineChart:
        return StackedLineSeries<FakeData, DateTime>(
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.StackedareaChart:
        return StackedAreaSeries<FakeData, DateTime>(
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.StackedcolumnChart:
        return StackedColumnSeries<FakeData, DateTime>(
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.BoxandWhiskerChart:
        return BoxAndWhiskerSeries<FakeData, DateTime>(
          dataSource: city,
          boxPlotMode: BoxPlotMode.exclusive,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );

      default:
    }
  }

  _xValueMapper(FakeData sales) {
    return DateTime.parse(sales.time);
  }

  _xValueMapperCat(CatName sales) {
    return sales.location;
  }

  _yValueMapper(FakeData sales, selected) {
    if (selected == describeEnum(yAxisSingle.Gas))
      return double.parse(sales.gas);
    if (selected == describeEnum(yAxisSingle.Temperature))
      return double.parse(sales.temperature);
    if (selected == describeEnum(yAxisSingle.Pressure))
      return double.parse(sales.pressure);
    if (selected == describeEnum(yAxisSingle.Ozone))
      return double.parse(sales.ozone);
    if (selected == describeEnum(yAxisSingle.Humidity))
      return double.parse(sales.humidity);
    if (selected == describeEnum(yAxisSingle.PM)) return double.parse(sales.pm);
  }

  location(List<CatName> data, selected) {
    switch (selectedGraph.value) {
      case graphs.Bubble:
        return BubbleSeries<CatName, String>(
          dataSource: data,
          xValueMapper: (CatName sales, _) => _xValueMapperCat(sales),
          yValueMapper: (CatName sales, _) =>
              _yValueMapper(sales.data, selected),
        );
      case graphs.Column:
        return ColumnSeries<CatName, String>(
          dataSource: data,
          xValueMapper: (CatName sales, _) => _xValueMapperCat(sales),
          yValueMapper: (CatName sales, _) =>
              _yValueMapper(sales.data, selected),
        );

      case graphs.CircularDoughnutChart:
        return DoughnutSeries<CatName, String>(
          dataSource: data,
          xValueMapper: (CatName sales, _) => _xValueMapperCat(sales),
          yValueMapper: (CatName sales, _) =>
              _yValueMapper(sales.data, selected),
        );
      case graphs.CircularRadialBarChart:
        return RadialBarSeries<CatName, String>(
          dataSource: data,
          xValueMapper: (CatName sales, _) => _xValueMapperCat(sales),
          yValueMapper: (CatName sales, _) =>
              _yValueMapper(sales.data, selected),
        );
      case graphs.circularpieChart:
        return PieSeries<CatName, String>(
          dataSource: data,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          xValueMapper: (CatName sales, _) => _xValueMapperCat(sales),
          yValueMapper: (CatName sales, _) =>
              _yValueMapper(sales.data, selected),
        );
      case graphs.pyramidChart:
        return PyramidSeries<CatName, String>(
          dataSource: data,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          xValueMapper: (CatName sales, _) => _xValueMapperCat(sales),
          yValueMapper: (CatName sales, _) =>
              _yValueMapper(sales.data, selected),
        );
      default:
    }
  }

  _getSeries(List<List<FakeData>> cityData) {
    List<ChartSeries> chartSeries = <ChartSeries>[];
    List<CircularSeries> circularSeries = <CircularSeries>[];
    PyramidSeries pyramidSeries = PyramidSeries();
    List<CatName> namesData = [];
    String name = '';
    //if series is location:
    // if(selectedGraph.value == graphs.pyramidChart

    //selected date types
    if (selectedXPlot.value == xAxis.locations) {
      if (singleDatePicker.value) {
        for (var i = 0; i < cityData.length; i++) {
          switch (i) {
            case 0:
              name = describeEnum(cities.Abuja);
              break;
            case 1:
              name = describeEnum(cities.Ghana);
              break;

            case 2:
              name = describeEnum(cities.Coast);

              break;
            default:
          }
          var particularDay = cityData[i];
          double temp = 0.0,
              humidity = 0.0,
              pm = 0.0,
              pressure = 0.0,
              ozone = 0.0,
              gas = 0.0;
          String time = '';
          particularDay.forEach((hourly) {
            temp += double.parse(hourly.temperature);
            humidity += double.parse(hourly.humidity);
            pm += double.parse(hourly.pm);
            pressure += double.parse(hourly.pressure);
            ozone += double.parse(hourly.ozone);
            gas += double.parse(hourly.gas);
          });
          var dayDataAvg = FakeData(
              temperature: (temp / 24).toString(),
              humidity: (humidity / 24).toString(),
              pm: (pm / 24).toString(),
              ozone: (ozone / 24).toString(),
              pressure: (pressure / 24).toString(),
              gas: (gas / 24).toString(),
              time: time);
          namesData.add(CatName(data: dayDataAvg, location: name));
        }
      } else if (!singleDatePicker.value) {
        for (var i = 0; i < cityData.length; i++) {
          switch (i) {
            case 0:
              name = describeEnum(cities.Abuja);
              break;
            case 1:
              name = describeEnum(cities.Ghana);
              break;

            case 2:
              name = describeEnum(cities.Coast);

              break;
            default:
          }
          var dailyData = cityData[i];

          int numberofDays = dailyData.length;
          double temp = 0.0,
              humidity = 0.0,
              pm = 0.0,
              pressure = 0.0,
              ozone = 0.0,
              gas = 0.0;
          String time = '';
          dailyData.forEach((element) {
            gas += double.parse(element.gas);
            temp += double.parse(element.temperature);
            humidity += double.parse(element.humidity);
            ozone += double.parse(element.ozone);
            pm += double.parse(element.pm);
            pressure += double.parse(element.pressure);
          });
          namesData.add(CatName(
              data: FakeData(
                  temperature: (temp / numberofDays).toString(),
                  humidity: (humidity / numberofDays).toString(),
                  pm: (pm / numberofDays).toString(),
                  ozone: (ozone / numberofDays).toString(),
                  pressure: (pressure / numberofDays).toString(),
                  gas: (gas / numberofDays).toString()),
              location: name));
        }
      }

      //selected graph types
      if (selectedGraph.value == graphs.CircularDoughnutChart ||
          selectedGraph.value == graphs.CircularRadialBarChart ||
          selectedGraph.value == graphs.circularpieChart) {
        for (var selected in selectedData) {
          circularSeries.add(location(namesData, selected));
        }
        return circularSeries;
      } else if (selectedGraph.value == graphs.pyramidChart) {
        // for (var selected in selectedData) {
        pyramidSeries = location(namesData, selectedData[0]);
        // }
        return pyramidSeries;
      } else {
        for (var selected in selectedData) {
          chartSeries.add(location(namesData, selected));
        }
        return chartSeries;
      }
    } else {
      //regular number stuffs
      for (var city in cityData) {
        for (var selected in selectedData) {
          chartSeries.add(_tril(city, selected));
        }
      }
      return chartSeries;
    }
  }

  List<List<FakeData>> datacleaning(List<Map<String, List<FakeData>>> rawdata) {
    List<FakeData> dailyData = [];
    List<List<FakeData>> cityData = [];
    if (selectedXPlot.value == xAxis.hr && !singleDatePicker.value) {
      for (var i = 0; i < 24; i++) {
        dailyData.add(FakeData(
            temperature: "0.0",
            humidity: "0.0",
            pm: "0.0",
            ozone: "0.0",
            pressure: "0.0",
            gas: "0.0"));
      }
      for (var i = 0; i < 24; i++) {
        dailyData[i].time = DateTime(2021, 08, 1, i).toString();

        rawdata.forEach((data) {
          data.keys.forEach((datetime) {
            if (selectedDatesRange.contains(datetime)) {
              data[datetime]!.forEach((element) {
                dailyData[i].gas =
                    (double.parse(dailyData[i].gas) + double.parse(element.gas))
                        .toString();
                dailyData[i].temperature =
                    (double.parse(dailyData[i].temperature) +
                            double.parse(element.temperature))
                        .toString();
                dailyData[i].humidity = (double.parse(dailyData[i].humidity) +
                        double.parse(element.humidity))
                    .toString();
                dailyData[i].ozone = (double.parse(dailyData[i].ozone) +
                        double.parse(element.ozone))
                    .toString();
                dailyData[i].pm =
                    (double.parse(dailyData[i].pm) + double.parse(element.pm))
                        .toString();
                dailyData[i].pressure = (double.parse(dailyData[i].pressure) +
                        double.parse(element.pressure))
                    .toString();
              });
              cityData.add(dailyData);
            }
          });
        });
      }

      cityData.forEach((dailyData) {
        dailyData.forEach((element) {
          element.gas =
              (double.parse(element.gas) / dailyData.length).toString();
          element.temperature =
              (double.parse(element.temperature) / dailyData.length).toString();
          element.humidity =
              (double.parse(element.humidity) / dailyData.length).toString();
          element.ozone =
              (double.parse(element.ozone) / dailyData.length).toString();
          element.pm = (double.parse(element.pm) / dailyData.length).toString();
          element.pressure =
              (double.parse(element.pressure) / dailyData.length).toString();
        });
      });
      return cityData;
    } else if ((selectedXPlot.value == xAxis.hr && singleDatePicker.value) ||
        (selectedXPlot.value == xAxis.locations && singleDatePicker.value)) {
      //get data of selected date
      rawdata.forEach((citydata) {
        var particularDayData = citydata[userSelectedDate.toString()]!;
        cityData.add(particularDayData);
      });
      return cityData;
    } else if ((!singleDatePicker.value && selectedXPlot.value == xAxis.day) ||
        (selectedXPlot.value == xAxis.locations && !singleDatePicker.value)) {
      //return average over days
      double temp = 0.0,
          humidity = 0.0,
          pm = 0.0,
          pressure = 0.0,
          ozone = 0.0,
          gas = 0.0;
      String time = '';
      rawdata.forEach((citydata) {
        citydata.keys.forEach((datetime) {
          if (selectedDatesRange.contains(datetime)) {
            citydata[datetime]!.forEach((hourlyData) {
              temp += double.parse(hourlyData.temperature);
              humidity += double.parse(hourlyData.humidity);
              pm += double.parse(hourlyData.pm);
              pressure += double.parse(hourlyData.pressure);
              ozone += double.parse(hourlyData.ozone);
              gas += double.parse(hourlyData.gas);
              time = hourlyData.time;
            });
            var dayDataAvg = FakeData(
                temperature: (temp / 24).toString(),
                humidity: (humidity / 24).toString(),
                pm: (pm / 24).toString(),
                ozone: (ozone / 24).toString(),
                pressure: (pressure / 24).toString(),
                gas: (gas / 24).toString(),
                time: time);
            dailyData.add(dayDataAvg);
            temp = 0.0;
            humidity = 0.0;
            pm = 0.0;
            pressure = 0.0;
            ozone = 0.0;
            gas = 0.0;
          }
        });

        cityData.add(dailyData);
      });
      return cityData;
    }
    return [];
  }

  Widget graphSettings(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  // Get.back();
                  Get.defaultDialog(
                      title: "Make Selections",
                      content: showSettingsPopUp(context),
                      onConfirm: () {
                        selectgraph.value = true;
                        Get.back();
                      },
                      onCancel: () => Get.back());
                },
                child: Text("change graph")),
            Text("current settings"),
            ElevatedButton(
                onPressed: () async => Get.defaultDialog(
                      content: SingleChildScrollView(
                          child: await colorPickerDialog()),
                    ),
                child: Text("Change background color")),
            Row(children: [
              Text("show graphaxis: "),
              Obx(() {
                return Switch(
                    value: showgraphAxis.value,
                    onChanged: (value) => showgraphAxis.value = value);
              })
            ]),
            Row(children: [
              Text("show legend: "),
              Obx(() {
                return Switch(
                    value: showlegend.value,
                    onChanged: (value) => showlegend.value = value);
              })
            ]),
            Row(children: [
              Text("show title: "),
              Obx(() {
                return Switch(
                    value: showtitle.value,
                    onChanged: (value) => showtitle.value = value);
              })
            ]),
            Row(children: [
              Text("show x-axis name: "),
              Obx(() {
                return Switch(
                    value: showXName.value,
                    onChanged: (value) => showXName.value = value);
              })
            ]),
            Row(children: [
              Text("show y-axis name: "),
              Obx(() {
                return Switch(
                    value: showYName.value,
                    onChanged: (value) => showYName.value = value);
              })
            ]),
          ],
        ),
      ),
    );
  }

  colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: plotAreaBackgroundColor.value,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) {
        var colorred = MaterialColor(int.parse('0x' + color.hexAlpha),
            <int, Color>{50: Color(int.parse('0x' + color.hexAlpha))});
        plotAreaBackgroundColor.value = colorred;
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,

      wheelSubheading: Text(
        'Selected color and its shades',
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
    );
  }

  RxList<String> selectedCities = <String>[].obs;
  RxList<String> selectedData = <String>[].obs;
  Widget showSettingsPopUp(context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Row(
            //   children: [
            ElevatedButton(
                onPressed: () async {
                  await FilterListDialog.display<String>(
                    Get.context,
                    hideSearchField: true,
                    choiceChipLabel: (item) => item,
                    listData:
                        cities.values.map((e) => describeEnum(e)).toList(),
                    onApplyButtonClick: (list) {
                      selectedCities.value = List.from(list!);
                      Get.back();
                    },
                    onItemSearch: (list, String text) => list!,
                    validateSelectedItem: (list, item) => list!.contains(item),
                  );
                },
                child: Text("Select City")),
            ElevatedButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: "Select Date",
                      content: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Multiple"),
                                  Obx(() => Switch(
                                      value: singleDatePicker.value,
                                      onChanged: (da) {
                                        selectedXPlot.value = xAxis.day;
                                        singleDatePicker.value = da;
                                      })),
                                  Text("Single"),
                                ],
                              ),
                              Obx(() {
                                return Container(
                                  width: 300,
                                  height: 300,
                                  child: SfDateRangePicker(
                                    view: DateRangePickerView.month,
                                    selectionMode: singleDatePicker.value
                                        ? DateRangePickerSelectionMode.single
                                        : DateRangePickerSelectionMode.range,
                                    onSelectionChanged: _onSelectionChanged,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      onConfirm: () {
                        // selectgraph.value = true;
                        Get.back();
                      },
                      onCancel: () => Get.back());
                  // DatePicker.showDatePicker(context,
                  //     showTitleActions: true,
                  //     minTime: DateTime(2021, 8, 1),
                  //     maxTime: DateTime(2021, 9, 30),
                  //     currentTime: DateTime.now(), onConfirm: (newDate) {
                  //   selectedDate.value = newDate;
                  // });
                },
                child: Text("Select date")),
            Row(
              children: [
                Text("Select Graph Type     "),
                Obx(() {
                  return DropdownButton(
                      onChanged: (newvalue) =>
                          selectedGraph.value = newvalue as graphs,
                      value: selectedGraph.value,
                      items: graphs.values
                          .map((e) => DropdownMenuItem(
                              value: e, child: Text(describeEnum(e))))
                          .toList());
                })
              ],
            ),
            Row(
              children: [
                Text("Plot X:     "),
                Obx(() {
                  return DropdownButton(
                      onChanged: (value) =>
                          selectedXPlot.value = value as xAxis,
                      value: selectedXPlot.value,
                      items: xAxis.values
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(describeEnum(e)),
                              ))
                          .toList());
                }),
                Text("     vs     "),
                Text("Y:     "),
                ElevatedButton(
                    onPressed: () async {
                      await FilterListDialog.display<String>(
                        context,
                        hideSearchField: true,
                        choiceChipLabel: (item) => item,
                        listData: yAxisSingle.values
                            .map((e) => describeEnum(e))
                            .toList(),
                        onApplyButtonClick: (list) {
                          selectedData.value = List.from(list!);
                          Get.back();
                        },
                        onItemSearch: (list, String text) => list!,
                        validateSelectedItem: (list, item) =>
                            list!.contains(item),
                      );
                    },
                    child: Text("Select y-values"))
              ],
            )
          ],
        ),
      ),
    );
  }

  List<String> selectedDatesRange = [];
  DateTime userSelectedDate = DateTime.now();
  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    final List<String> ranges = [];

    if (args.value is PickerDateRange) {
      final DateTime rangeStartDate = args.value.startDate;
      // print(rangeStartDate);
      final DateTime rangeEndDate = args.value.endDate;
      // print(rangeEndDate);

      for (int i = 0;
          i <= rangeEndDate.difference(rangeStartDate).inDays;
          i++) {
        ranges.add(rangeStartDate.add(Duration(days: i)).toString());
        selectedDatesRange = ranges;
      }
      selectedDatesRange.forEach((element) {
        // print(element);
      });
    } else if (args.value is DateTime) {
      final DateTime selectedDate = args.value;
      this.userSelectedDate = selectedDate;
    } else if (args.value is List<DateTime>) {
      final List<DateTime> selectedDates = args.value;
      selectedDates.forEach((element) {
        ranges.add(element.toString());
      });
      selectedDatesRange = ranges;
    } else {
      final List<PickerDateRange> selectedRanges = args.value;
    }
  }
}

class CatName {
  FakeData data;
  String location;
  CatName({
    required this.data,
    required this.location,
  });
}
