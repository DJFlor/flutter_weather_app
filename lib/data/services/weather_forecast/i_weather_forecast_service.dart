import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/location.dart';
import 'package:flutter_weather_app/data/models/weather_forecast.dart';

abstract class IWeatherForecastService {
  Future<APIResponse<WeatherForecast>> getWeatherForecast(Location location);
}
