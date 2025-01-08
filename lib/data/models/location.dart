class Location {
  final String? name;
  final String? region;
  final String? country;
  final double lat;
  final double lon;
  final String? tz;
  final int localTimeEpoch;
  final String? localTime;

  const Location({
    this.name,
    this.region,
    this.country,
    required this.lat,
    required this.lon,
    this.tz,
    required this.localTimeEpoch,
    this.localTime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
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
