import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/current_weather.dart';
import 'package:flutter_weather_app/data/models/location.dart';

abstract class ICurrentWeatherService {
  Future<APIResponse<CurrentWeather>> getCurrentWeather(Location location);
}
