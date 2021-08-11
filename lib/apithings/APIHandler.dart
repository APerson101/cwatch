import 'dart:convert';

import 'package:cwatch/app/models/weathermodel.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class APIHandler {
  final String APIKEY = '6489a7ca3aa40421818eb351a8f77b6a';
  final String abjLang = '9.0765';
  final String abjLong = '7.3986';

  Future<CurrentandForecast> getDataOneCall() async {
    String url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$abjLang&lon=$abjLong&exclude={minutely,hourly,alerts}&appid=$APIKEY';
    // Response res = await http.get(Uri.parse(url));
    // print(jsonDecode(res.body));
    // print(jsonDecode(res.body)["lat"]);
    // print(jsonDecode(res.body)["lon"]);
    // print(jsonDecode(res.body)["current"]["weather"][0]["main"]);
    // print(jsonDecode(res.body)["current"]["weather"][0]["description"]);
    // print(jsonDecode(res.body)["daily"][0]);
    // var thong = CurrentandForecast.fromMap(jsonDecode(res.body));
    var thong = CurrentandForecast();
    // print(thong.toString());
    return thong;
  }
}
