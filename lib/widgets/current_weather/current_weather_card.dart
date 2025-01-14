import 'package:flutter/material.dart';
import 'package:flutter_weather_app/data/models/current_weather.dart';
import 'package:flutter_weather_app/data/models/forecast_day.dart';
import 'package:flutter_weather_app/data/models/location.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({
    super.key,
    required this.location,
    this.currentWeather,
    this.todaysForecast,
  });

  final Location location;
  final CurrentWeather? currentWeather;
  final ForecastDay? todaysForecast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = TextStyle(
      color: theme.colorScheme.onPrimary,
    );
    final String? imageUrl = currentWeather?.currentCondition.iconURL != null
        ? "http:${currentWeather!.currentCondition.iconURL!.replaceAll('64x64', '128x128')}"
        : null;

    return Card(
      color: theme.colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Weather in Namme:
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
            child: Text(
              "Weather in ${location.name}",
              style: style.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Region, Country:
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
            child: Text(
              "${location.region}, ${location.country}",
              style: style.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          // Date and Time:
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
            child: Text(
              currentWeather?.lastUpdated ?? "--:--",
              style: style.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          // Temperature:
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
            child: Text(
              "${currentWeather?.tempF ?? "--"} F",
              style: style.copyWith(fontSize: 36, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Min / Max:
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: Text(
              "min ${todaysForecast?.minTempF ?? "--"} / max ${todaysForecast?.maxTempF ?? "--"}",
              style: style.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          // Min / Max:
          Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      width: 128,
                      height: 128,
                      fit: BoxFit.fill,
                    )
                  : SizedBox(width: 128, height: 128)),
          // Condition Text:
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20),
            child: Text(
              currentWeather?.currentCondition.text ?? " ",
              style: style.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
