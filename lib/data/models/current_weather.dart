import 'condition.dart';

class CurrentWeather {
  final int lastUpdatedTS;
  final String lastUpdated;
  final double tempC;
  final double tempF;
  final Condition currentCondition;

  const CurrentWeather({
    required this.lastUpdatedTS,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.currentCondition,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    // First deserialize the nested current condition"
    final conditionJson = json['condition'] as Map<String, dynamic>;
    final currentCondition = Condition.fromJson(conditionJson);
    // Then deserialize the rest of the current data:
    return CurrentWeather(
      lastUpdatedTS: json['last_updated_epoch'],
      lastUpdated: json['last_updated'],
      tempC: json['temp_c'],
      tempF: json['temp_f'],
      currentCondition: currentCondition,
    );
  }
}
