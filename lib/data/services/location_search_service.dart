import 'dart:convert';

import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/location.dart';

import 'package:http/http.dart' as http;

class LocationSearchService {
  static const url =
      'http://api.weatherapi.com/v1/search.json?key=16309e007f0f40a5a80123044221507&q=';

  Future<APIResponse<List<Location>>> getLocationList(String location) {
    // print("** Searching for: $location");
    return http.get(Uri.parse(url + location)).then((value) {
      // print("** Response status code: ${value.statusCode}");
      // print("** Response body: ${value.body}");
      // Evaluate the response code:
      switch (value.statusCode) {
        /** HTTP OK: valid response with List of 0 to more Locations **/
        case 200:
          // Decode the json data list:
          final jsonData = json.decode(value.body) as List;
          // Map the list elements to Locations, aggregated as a list:
          final locationListData =
              jsonData.map((data) => Location.fromJson(data)).toList();
          // Ship the response:
          return APIResponse<List<Location>>(data: locationListData);

        /** ALL OTHER RESPONSE CODES ARE FAILURES **/
        default:
          return APIResponse<List<Location>>(
              isError: true,
              errorMessage: 'API Error getting location list for: $location');
      }
    }).catchError((err) => APIResponse<List<Location>>(
        isError: true,
        errorMessage: 'SYSTEM Error getting location: $location'));
  }
}
