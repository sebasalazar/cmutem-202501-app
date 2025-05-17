import 'dart:convert';

import 'package:hm/model/weather_data.dart';

class WeatherInfo {
  String status;
  WeatherData data;

  WeatherInfo({required this.status, required this.data});

  factory WeatherInfo.fromRawJson(String str) =>
      WeatherInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => WeatherInfo(
    status: json["status"],
    data: WeatherData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"status": status, "data": data.toJson()};
}
