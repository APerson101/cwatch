import 'dart:convert';

import 'package:flutter/foundation.dart';

class HourlyDataModel {
  String temperature;
  String pressure;
  String pm;
  String ozone;
  String gas;
  String humidity;
  HourlyDataModel({
    required this.temperature,
    required this.pressure,
    required this.pm,
    required this.ozone,
    required this.gas,
    required this.humidity,
  });

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'pressure': pressure,
      'pm': pm,
      'ozone': ozone,
      'gas': gas,
      'humidity': humidity,
    };
  }

  factory HourlyDataModel.fromMap(Map<String, dynamic> map) {
    return HourlyDataModel(
      temperature: map['temperature'],
      pressure: map['pressure'],
      pm: map['pm'],
      ozone: map['ozone'],
      gas: map['gas'],
      humidity: map['humidity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HourlyDataModel.fromJson(String source) =>
      HourlyDataModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HourlyDataModel(temperature: $temperature, pressure: $pressure, pm: $pm, ozone: $ozone, gas: $gas, humidity: $humidity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HourlyDataModel &&
        other.temperature == temperature &&
        other.pressure == pressure &&
        other.pm == pm &&
        other.ozone == ozone &&
        other.gas == gas &&
        other.humidity == humidity;
  }

  @override
  int get hashCode {
    return temperature.hashCode ^
        pressure.hashCode ^
        pm.hashCode ^
        ozone.hashCode ^
        gas.hashCode ^
        humidity.hashCode;
  }
}

class DailyDataModel {
  Map<String, HourlyDataModel> dayData;
  String date;
  DailyDataModel({
    required this.dayData,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> thing = {};
    dayData.forEach((key, value) {
      thing.addAll({key: value.toMap()});
    });
    return thing;
  }

  String toJson() => json.encode(toMap());

  factory DailyDataModel.fromJson(String source) =>
      DailyDataModel.fromMap(json.decode(source));

  @override
  String toString() => 'DailyDataModel(dayData: $dayData, date: $date)';

  factory DailyDataModel.fromMap(Map<String, dynamic> map) {
    return DailyDataModel(
      dayData: Map<String, HourlyDataModel>.from(map['dayData']),
      date: map['date'],
    );
  }
}

class LocationDataModel {
  String location;
  Map<String, DailyDataModel> locationData;
  LocationDataModel({
    required this.location,
    required this.locationData,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> thing = {};
    locationData.forEach((key, value) {
      thing.addAll({key: value.toMap()});
    });
    return {location: thing};
  }

  @override
  String toString() =>
      'LocationDataModel(location: $location, locationData: $locationData)';

  factory LocationDataModel.fromMap(Map<String, dynamic> map) {
    return LocationDataModel(
      location: map['location'],
      locationData: Map<String, DailyDataModel>.from(map['locationData']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationDataModel.fromJson(String source) =>
      LocationDataModel.fromMap(json.decode(source));
}
