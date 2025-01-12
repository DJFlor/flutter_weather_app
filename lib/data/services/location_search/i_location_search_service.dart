import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/location.dart';

abstract class ILocationSearchService {
  Future<APIResponse<List<Location>>> getLocationList(String location);
}
