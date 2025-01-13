import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/condition.dart';
import 'package:flutter_weather_app/data/models/current_weather.dart';
import 'package:flutter_weather_app/data/models/location.dart';
import 'package:flutter_weather_app/data/services/current_weather/i_current_weather_service.dart';

class MockCurrentWeatherService implements ICurrentWeatherService {
  /// the number of ms to delay the return
  int latency;

  /// optional errorMessage, triggers error response
  String? errorMessage;

  MockCurrentWeatherService({
    this.latency = 0, // default 0ms delay
    this.errorMessage, // default null
  });

  @override
  Future<APIResponse<CurrentWeather>> getCurrentWeather(Location location) =>
      Future(() async {
        // delay if apropriate
        if (latency > 0) {
          await Future.delayed(Duration(milliseconds: latency));
        }
        // formulate response
        return APIResponse(
          // data is populated if errorMessage is null
          data: errorMessage != null
              ? null
              : CurrentWeather(
                  lastUpdatedTS: 0,
                  lastUpdated: "Epoch + 0:00",
                  tempC: 0,
                  tempF: 32,
                  currentCondition: Condition(
                    text: "Cold and clear",
                    iconURL: null,
                    code: 0,
                  )),
          isError: errorMessage != null,
          errorMessage: errorMessage,
        );
      });
}
