import 'package:cwatch/apithings/APIHandler.dart';
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
  RxInt index;
  Rx<graphs> selectedGraph = graphs.lineChart.obs;
  DefaultGraph({Key? key, required this.index}) : super(key: key);
  VisualizerController Visualcontroller = Get.find();

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
    if (Visualcontroller.allData.isEmpty)
      return CircularProgressIndicator.adaptive();
    selectedCities.forEach((city) {
      rawdata.add(Visualcontroller.allData[city]!);
      // print(Visualcontroller.allData[city]!);
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
                  title: showXName.value ? AxisTitle(text: "location") : null,
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
                      ? AxisTitle(
                          text:
                              selectedXPlot.value == xAxis.day ? "day" : "time")
                      : null),
          primaryYAxis: NumericAxis(
              majorGridLines:
                  MajorGridLines(width: showgraphAxis.value ? 0.7 : 0),
              title: showYName.value ? AxisTitle(text: getYAxisName()) : null),
          series: _getSeries(graphData));
    }
    return Column(
      children: [
        Visualcontroller.expandImage.value
            ? Container()
            : Row(
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
        Expanded(child: child),
      ],
    );
  }

  String getYAxisName() {
    switch (selectedData.value) {
      case yAxisSingle.Gas:
        return "gas";
      case yAxisSingle.Temperature:
        return "Temperature";
      case yAxisSingle.Ozone:
        return "Ozone";
      case yAxisSingle.Pressure:
        return "Pressure";
      case yAxisSingle.Humidity:
        return "Humidity";
      case yAxisSingle.PM:
        return "Particulate Matter";
      default:
        return " ";
    }
  }

  _tril(city, String cityName, selected) {
    switch (selectedGraph.value) {
      case graphs.lineChart:
        return FastLineSeries<FakeData, DateTime>(
          dataSource: city,
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.AreaChart:
        return AreaSeries<FakeData, DateTime>(
          dataSource: city,
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.Bubble:
        return BubbleSeries<FakeData, DateTime>(
          dataSource: city,
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.Column:
        return ColumnSeries<FakeData, DateTime>(
          dataSource: city,
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.Scatter:
        return ScatterSeries<FakeData, DateTime>(
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.StepLine:
        return StepLineSeries<FakeData, DateTime>(
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.StepareaChart:
        return StepAreaSeries<FakeData, DateTime>(
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.HistogramChart:
        return HistogramSeries<FakeData, DateTime>(
            name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
            dataSource: city,
            yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
            showNormalDistributionCurve: true);

      case graphs.StackedlineChart:
        return StackedLineSeries<FakeData, DateTime>(
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.StackedareaChart:
        return StackedAreaSeries<FakeData, DateTime>(
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.StackedcolumnChart:
        return StackedColumnSeries<FakeData, DateTime>(
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
          dataSource: city,
          xValueMapper: (FakeData sales, _) => _xValueMapper(sales),
          yValueMapper: (FakeData sales, _) => _yValueMapper(sales, selected),
        );
      case graphs.BoxandWhiskerChart:
        return BoxAndWhiskerSeries<FakeData, DateTime>(
          name: singleDatePicker.value ? "time-$cityName" : "day-$cityName",
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
    if (selected == yAxisSingle.Gas) return double.parse(sales.gas);
    if (selected == yAxisSingle.Temperature)
      return double.parse(sales.temperature);
    if (selected == yAxisSingle.Pressure) return double.parse(sales.pressure);
    if (selected == yAxisSingle.Ozone) return double.parse(sales.ozone);
    if (selected == yAxisSingle.Humidity) return double.parse(sales.humidity);
    if (selected == yAxisSingle.PM) return double.parse(sales.pm);
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
      case graphs.Scatter:
        return ScatterSeries<CatName, String>(
          dataSource: data,
          xValueMapper: (CatName sales, _) => _xValueMapperCat(sales),
          yValueMapper: (CatName sales, _) =>
              _yValueMapper(sales.data, selected),
        );
      case graphs.StackedcolumnChart:
        return StackedColumnSeries<CatName, String>(
          dataSource: data,
          xValueMapper: (CatName sales, _) => _xValueMapperCat(sales),
          yValueMapper: (CatName sales, _) =>
              _yValueMapper(sales.data, selected),
        );
      case graphs.StackedareaChart:
        return StackedAreaSeries<CatName, String>(
          dataSource: data,
          xValueMapper: (CatName sales, _) => _xValueMapperCat(sales),
          yValueMapper: (CatName sales, _) =>
              _yValueMapper(sales.data, selected),
        );
      case graphs.StackedlineChart:
        return StackedLineSeries<CatName, String>(
          dataSource: data,
          xValueMapper: (CatName sales, _) => _xValueMapperCat(sales),
          yValueMapper: (CatName sales, _) =>
              _yValueMapper(sales.data, selected),
        );
      case graphs.lineChart:
        return LineSeries<CatName, String>(
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

    //selected date types
    if (selectedXPlot.value == xAxis.locations) {
      if (singleDatePicker.value) {
        for (var i = 0; i < cityData.length; i++) {
          switch (i) {
            case 0:
              name = describeEnum(AllActiveLocations.Abuja);
              break;
            case 1:
              name = describeEnum(AllActiveLocations.Accra);
              break;

            case 2:
              name = describeEnum(AllActiveLocations.Abidjan);

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
              name = describeEnum(AllActiveLocations.Abuja);
              break;
            case 1:
              name = describeEnum(AllActiveLocations.Accra);
              break;

            case 2:
              name = describeEnum(AllActiveLocations.Abidjan);
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
        circularSeries.add(location(namesData, selectedData.value));
        return circularSeries;
      } else if (selectedGraph.value == graphs.pyramidChart) {
        // for (var selected in selectedData) {
        pyramidSeries = location(namesData, selectedData.value);
        return pyramidSeries;
      } else {
        chartSeries.add(location(namesData, selectedData.value));
        return chartSeries;
      }
    } else {
      //regular number stuffs
      for (int i = 0; i < cityData.length; i++) {
        var city = cityData[i];
        String cityname = selectedCities.value[i];
        chartSeries.add(_tril(city, cityname, selectedData.value));
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
      int count = 0;
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
        dailyData = [];
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
            ElevatedButton(
                onPressed: () {
                  Visualcontroller.deletegraph(index: index.value);
                },
                child: Text("delete graph")),
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

  RxList<graphs> locationDependentGraphs = [
    graphs.pyramidChart,
    graphs.circularpieChart,
    graphs.CircularDoughnutChart,
    graphs.CircularRadialBarChart,
  ].obs;
  RxList<String> selectedCities = <String>[].obs;
  Rx<yAxisSingle> selectedData = yAxisSingle.Temperature.obs;
  Widget showSettingsPopUp(context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
                  onPressed: () async {
                    await FilterListDialog.display<String>(
                      Get.context,
                      hideSearchField: true,
                      choiceChipLabel: (item) => item,
                      listData: AllActiveLocations.values
                          .map((e) => describeEnum(e))
                          .toList(),
                      onApplyButtonClick: (list) {
                        selectedCities.value = List.from(list!);
                        Get.back();
                      },
                      onItemSearch: (list, String text) => list!,
                      validateSelectedItem: (list, item) =>
                          list!.contains(item),
                    );
                  },
                  child: Text("Select City"))
              .padding(all: 15),
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
                                      minDate: DateTime(2021, 07, 1),
                                      maxDate: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day - 1),
                                      view: DateRangePickerView.month,
                                      initialSelectedDate: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day - 1),
                                      initialSelectedRanges: [
                                        PickerDateRange(
                                            DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day - 2),
                                            DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day - 1))
                                      ],
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
                  },
                  child: Text("Select date"))
              .padding(all: 15),
          Text("Select Graph Type     "),
          Obx(() {
            return DropdownButton(
                underline: Container(),
                onChanged: (newvalue) {
                  if (locationDependentGraphs.value.contains(newvalue)) {
                    selectedXPlot.value = xAxis.locations;
                  }
                  selectedGraph.value = newvalue as graphs;
                },
                value: selectedGraph.value,
                items: graphs.values.map((e) {
                  return DropdownMenuItem(
                      value: e, child: Text(describeEnum(e)));
                }).toList());
          }).padding(all: 15),
          Text("Plot X:     "),
          Obx(() {
            return DropdownButton(
                underline: Container(),
                onChanged: (value) => selectedXPlot.value = value as xAxis,
                value: selectedXPlot.value,
                items: getxAxisOptions());
          }),
          Text("     vs     "),
          Text("Y:     "),
          Obx(() {
            return DropdownButton(
                underline: Container(),
                onChanged: (newValue) =>
                    selectedData.value = newValue as yAxisSingle,
                value: selectedData.value,
                items: yAxisSingle.values
                    .map((e) => DropdownMenuItem(
                        value: e, child: Text(describeEnum(e))))
                    .toList());
          })
        ],
      ).padding(all: 15)),
    );
  }

  List<graphs> allOptions = [
    graphs.Column,
    graphs.Bubble,
    graphs.Scatter,
    graphs.StackedcolumnChart,
    graphs.StackedareaChart,
    graphs.StackedlineChart,
    graphs.lineChart
  ];
  getxAxisOptions() {
    if (allOptions.contains(selectedGraph.value) && singleDatePicker.value) {
      return xAxis.values
          .map((e) => DropdownMenuItem(value: e, child: Text(describeEnum(e))))
          .toList();
    } else if (allOptions.contains(selectedGraph.value) &&
        !singleDatePicker.value) {
      List<xAxis> vals = [xAxis.day, xAxis.locations];
      return vals
          .map((e) => DropdownMenuItem(value: e, child: Text(describeEnum(e))))
          .toList();
    }
    if (locationDependentGraphs.value.contains(selectedGraph.value)) {
      return [
        DropdownMenuItem(
          value: xAxis.locations,
          child: Text("location"),
        )
      ];
    }
    if (!singleDatePicker.value)
      return [
        DropdownMenuItem(
          value: xAxis.day,
          child: Text("days"),
        )
      ];
    else
      return [
        DropdownMenuItem(
          value: xAxis.locations,
          child: Text("location"),
        ),
        DropdownMenuItem(
          value: xAxis.hr,
          child: Text("hour"),
        ),
      ];
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
