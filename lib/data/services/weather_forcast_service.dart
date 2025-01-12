import 'dart:convert';

import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/weather_forecast.dart';
import 'package:flutter_weather_app/data/models/location.dart';

import 'package:http/http.dart' as http;

class WeatherForcastService {
  static const url =
      'http://api.weatherapi.com/v1/forecast.json?key=16309e007f0f40a5a80123044221507&days=1&aqi=no&alerts=no&q=';

  Future<APIResponse<WeatherForecast>> getWeatherForecast(Location location) {
    final locId = "id:${location.id}";
    // print("** Fetching weather forecast for: $locId");
    return http.get(Uri.parse(url + locId)).then((value) {
      // print("** Response status code: ${value.statusCode}");
      // print("** Response body: ${value.body}");
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body) as Map<String, dynamic>;
        // print("******JSON DATA: ${jsonData.toString()}");
        final weatherForecast = WeatherForecast.fromJson(jsonData);
        return APIResponse<WeatherForecast>(data: weatherForecast);
      }
      return APIResponse<WeatherForecast>(
          isError: true, errorMessage: 'API Error getting weather forecast');
    }).catchError((err) => APIResponse<WeatherForecast>(
        isError: true,
        errorMessage:
            'SYSTEM Error getting weather forecast: ${err.toString()}'));
  }
}
