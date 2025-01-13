// ignore_for_file: constant_identifier_names

import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/condition.dart';
import 'package:flutter_weather_app/data/models/current_weather.dart';
import 'package:flutter_weather_app/data/models/forecast_day.dart';
import 'package:flutter_weather_app/data/models/forecast_hour.dart';
import 'package:flutter_weather_app/data/models/location.dart';
import 'package:flutter_weather_app/data/models/weather_forecast.dart';
import 'package:flutter_weather_app/data/services/weather_forecast/i_weather_forecast_service.dart';

class MockWeatherForecastService implements IWeatherForecastService {
  /// the number of ms to delay the return
  int latency;

  /// optional errorMessage, triggers error response
  String? errorMessage;

  static const _min_ms = 60 * 1000;
  static const _hr_ms = 60 * _min_ms;

  MockWeatherForecastService({
    this.latency = 0, // default 0ms delay
    this.errorMessage, // default null
  });

  @override
  Future<APIResponse<WeatherForecast>> getWeatherForecast(Location location) =>
      Future(() async {
        // delay if apropriate
        if (latency > 0) {
          await Future.delayed(Duration(milliseconds: latency));
        }
        // formulate response
        final condition = Condition(
          text: "Cold and clear",
          iconURL: null,
          code: 0,
        );

        return APIResponse(
          // data is populated if errorMessage is null
          data: errorMessage != null
              ? null
              : WeatherForecast(
                  currentWeather: CurrentWeather(
                    lastUpdatedTS: 2 * _hr_ms + 30 * _min_ms,
                    lastUpdated: "Epoch plus 2:30",
                    tempC: 2.5,
                    tempF: 32 + 1.8 * 2.5,
                    currentCondition: condition,
                  ),
                  todaysForecast: ForecastDay(
                    dateTS: 0,
                    date: "Epoch + 0 day",
                    maxTempC: 12,
                    maxTempF: 32 + 1.8 * 12,
                    minTempC: 0,
                    minTempF: 32,
                    condition: condition,
                    hourlyForecasts: List.generate(24, (idx) {
                      double tc = idx > 12 ? 24.0 - idx : 1.0 * idx;
                      return ForecastHour(
                          forecastTimeTS: idx * _hr_ms,
                          forecastTime: "Epoch + $idx:00",
                          tempC: tc,
                          tempF: 32.0 + 1.0 * tc,
                          condition: condition,
                          chanceOfRain: 0,
                          chanceOfSnow: 0);
                    }),
                  )),
          isError: errorMessage != null,
          errorMessage: errorMessage,
        );
      });
}
