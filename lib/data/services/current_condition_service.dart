import 'dart:convert';

import 'package:flutter_weather_app/data/services/api_response.dart';
import 'package:flutter_weather_app/data/models/condition.dart';

import 'package:http/http.dart' as http;

class CurrentConditionService {
  static const url =
      'http://api.weatherapi.com/v1/current.json?key=16309e007f0f40a5a80123044221507&aqi=yes&q=';

  Future<APIResponse<Condition>> getCurrentCondition(String location) {
    return http.get(Uri.parse(url + location)).then((value) {
      if (value.statusCode == 200) {
        final jsonData = json.decode(value.body) as Map<String, dynamic>;
        final condition = Condition.fromJson(jsonData);
        return APIResponse<Condition>(data: condition);
      }
      return APIResponse<Condition>(
          isError: true, errorMessage: 'API Error getting list of users');
    }).catchError((err) => APIResponse<Condition>(
        isError: true, errorMessage: 'SYSTEM Error getting list of users'));
  }
}
