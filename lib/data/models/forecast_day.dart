import 'package:flutter_weather_app/data/models/forecast_hour.dart';

import 'condition.dart';

class ForecastDay {
  final int dateTS;
  final String date;
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final Condition condition;
  final List<ForecastHour> hourlyForecasts;

  const ForecastDay({
    required this.dateTS,
    required this.date,
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.condition,
    required this.hourlyForecasts,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    // Iteratively deserialize the forecast hours:
    // print("=====> deserializing hours list...");
    final hoursJson = json['hour'] as List;
    List<ForecastHour> hourlyForecasts = [];
    for (var hourDynamic in hoursJson) {
      final hourJson = hourDynamic as Map<String, dynamic>;
      // print("=====> deserializing hour ${hourJson['time']}...");
      hourlyForecasts.add(ForecastHour.fromJson(hourJson));
    }

    // print("=====> deserializing day...");
    // Next deserialize the rest of the forecast data for the day:
    final dayJson = json['day'] as Map<String, dynamic>;
    // including the nested current condition"
    // print("\n\n=====> deserializing condition... ${dayJson['condition']} \n\n");
    final conditionJson = dayJson['condition'] as Map<String, dynamic>;
    final condition = Condition.fromJson(conditionJson);

    return ForecastDay(
      dateTS: json['date_epoch'],
      date: json['date'],
      maxTempC: dayJson['maxtemp_c'],
      maxTempF: dayJson['maxtemp_f'],
      minTempC: dayJson['mintemp_c'],
      minTempF: dayJson['mintemp_f'],
      condition: condition,
      hourlyForecasts: hourlyForecasts,
    );
  }
}
