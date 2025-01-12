import 'package:flutter_weather_app/data/models/current_weather.dart';
import 'package:flutter_weather_app/data/models/forecast_day.dart';

class WeatherForecast {
  final CurrentWeather currentWeather;
  final ForecastDay todaysForecast;

  const WeatherForecast({
    required this.currentWeather,
    required this.todaysForecast,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    // Peel off and deserialize the current weather:
    final currentJson = json['current'] as Map<String, dynamic>;
    final currentWeather = CurrentWeather.fromJson(currentJson);

    // Peel off and deserialize today's forecast
    final forecastJson = json['forecast'] as Map<String, dynamic>;
    // print("****DESERIALIZING forecast: $forecastJson");
    final forecastDayListJson = forecastJson['forecastday'] as List;
    final forecastTodayJson = forecastDayListJson[0] as Map<String, dynamic>;
    // print("****DESERIALIZING forecast day: $forecastTodayJson");
    final todaysForecast = ForecastDay.fromJson(forecastTodayJson);

    return WeatherForecast(
      currentWeather: currentWeather,
      todaysForecast: todaysForecast,
    );
  }
}
