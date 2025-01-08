class Location {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String? tz;
  final int? localTimeEpoch;
  final String? localTime;

  const Location({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    this.tz,
    this.localTimeEpoch,
    this.localTime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'],
      lon: json['lon'],
      tz: json['tz_id'],
      localTimeEpoch: json['localtime_epoch'],
      localTime: json['localtime'],
    );
  }
}
