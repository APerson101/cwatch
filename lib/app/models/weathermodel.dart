import 'dart:convert';

class WeatherModel {
  double lat;
  double lon;
  Weather? weather;
  WeatherModel({
    this.lat = 0.0,
    this.lon = 0.0,
    this.weather,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      lat: map['lat'],
      lon: map['lon'],
      weather: Weather.fromMap(map['current']['weather'][0]),
    );
  }

  @override
  String toString() => 'WeatherModel(lat: $lat, lon: $lon, weather: $weather)';
}

class Weather {
  String? main;
  String? description;
  Weather({
    this.main = '',
    this.description = '',
  });

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      main: map['main'],
      description: map['description'],
    );
  }

  @override
  String toString() => 'Weather(main: $main, description: $description)';
}

class CurrentandForecast {
  WeatherModel? current;
  Weather? daily;
  CurrentandForecast({
    this.current,
    this.daily,
  });

  factory CurrentandForecast.fromMap(Map<String, dynamic> map) {
    return CurrentandForecast(
      current: WeatherModel.fromMap(map),
      daily: Weather.fromMap(map['daily'][0]['weather'][0]),
    );
  }

  @override
  String toString() => 'CurrentandForecast(current: $current, daily: $daily)';
}
