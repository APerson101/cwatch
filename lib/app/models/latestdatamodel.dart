import 'dart:convert';

class LatestDataModel {
  double temperature;
  double pressure;
  double pm;
  double ozone;
  double gas;
  double humidity;
  LatestDataModel({
    required this.temperature,
    required this.pressure,
    required this.pm,
    required this.ozone,
    required this.gas,
    required this.humidity,
  });
}
