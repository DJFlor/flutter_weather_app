class CurrentWeather {
  final double lat;
  final double lon;

  const CurrentWeather({
    required this.lat,
    required this.lon,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}
