import 'condition.dart';

class ForecastHour {
  final int forecastTimeTS;
  final String forecastTime;
  final double tempC;
  final double tempF;
  final Condition condition;
  final int chanceOfRain;
  final int chanceOfSnow;

  const ForecastHour({
    required this.forecastTimeTS,
    required this.forecastTime,
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.chanceOfRain,
    required this.chanceOfSnow,
  });

  factory ForecastHour.fromJson(Map<String, dynamic> json) {
    // First deserialize the nested current condition"
    final conditionJson = json['condition'] as Map<String, dynamic>;
    final condition = Condition.fromJson(conditionJson);

    // Then deserialize the rest of the forecast hour data:
    return ForecastHour(
      forecastTimeTS: json['time_epoch'],
      forecastTime: json['time'],
      tempC: json['temp_c'],
      tempF: json['temp_f'],
      condition: condition,
      chanceOfRain: json['chance_of_rain'],
      chanceOfSnow: json['chance_of_snow'],
    );
  }
}
