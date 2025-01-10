import 'dart:convert';

import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/current_weather.dart';
import 'package:flutter_weather_app/data/models/location.dart';

import 'package:http/http.dart' as http;

class CurrentWeatherService {
  static const url =
      'http://api.weatherapi.com/v1/current.json?key=16309e007f0f40a5a80123044221507&aqi=yes&q=';

  Future<APIResponse<CurrentWeather>> getCurrentWeather(Location location) {
    final locId = "id:${location.id}";
    print("** Fetching conditions for: $locId");
    return http.get(Uri.parse(url + locId)).then((value) {
      print("** Response status code: ${value.statusCode}");
      print("** Response body: ${value.body}");
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body) as Map<String, dynamic>;
        print("******JSON DATA: ${jsonData.toString()}");
        final currentData = jsonData['current']!;
        print("******CURRENT DATA: ${currentData.toString()}");
        final condition = CurrentWeather.fromJson(currentData);
        return APIResponse<CurrentWeather>(data: condition);
      }
      return APIResponse<CurrentWeather>(
          isError: true, errorMessage: 'API Error getting current conditions');
    }).catchError((err) => APIResponse<CurrentWeather>(
        isError: true,
        errorMessage:
            'SYSTEM Error getting current conditions: ${err.toString()}'));
  }
}
