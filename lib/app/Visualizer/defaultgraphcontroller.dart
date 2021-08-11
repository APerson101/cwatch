import 'package:get/get.dart';

enum xAxis { hr, day, locations }
enum yAxisAverage {
  AverageTemp,
  AverageHum,
  AveragePM,
  AverageGas,
  AverageOzone,
  AveragePressure
}
enum yAxisSingle { Temperature, Humidity, PM, Gas, Ozone, Pressure }

class DefaultGraphController extends GetxController {
  RxBool showgraphAxis = true.obs;

  RxBool showlegend = true.obs;

  RxBool showtitle = true.obs;

  RxBool showXName = true.obs;

  RxBool showYName = true.obs;

  Rx<xAxis> selectedXPlot = xAxis.hr.obs;
  Rx<yAxisAverage> selectedyAxisAvg = yAxisAverage.AverageTemp.obs;
  Rx<yAxisSingle> selectedyAxisSingle = yAxisSingle.Temperature.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  RxBool selectgraph = false.obs;

  RxInt selectedCity = 0.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  RxInt selectedGraph = 0.obs;
}
