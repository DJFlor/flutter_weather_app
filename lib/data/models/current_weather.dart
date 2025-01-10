class CurrentWeather {
  final int lastUpdatedTS;
  final String lastUpdated;

  const CurrentWeather(
      {required this.lastUpdatedTS, required this.lastUpdated});

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      lastUpdatedTS: json['last_updated_epoch'],
      lastUpdated: json['last_updated'],
    );
  }
}
