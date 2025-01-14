import 'package:flutter/material.dart';
import 'package:flutter_weather_app/data/models/forecast_hour.dart';

class ForecastHourListTile extends StatelessWidget {
  const ForecastHourListTile({
    super.key,
    required this.forecastHour,
  });

  final ForecastHour forecastHour;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = TextStyle(
      color: theme.colorScheme.onPrimary,
    );

    final iconUrl = forecastHour.condition.iconURL;
    final conditionText = forecastHour.condition.text != null
        ? "${forecastHour.condition.text} - "
        : "";
    return ListTile(
      tileColor: theme.primaryColorDark,
      titleTextStyle: style,
      subtitleTextStyle: style,
      leading: iconUrl != null
          ? Image.network(
              "http:$iconUrl",
              width: 64,
              height: 64,
              fit: BoxFit.fill,
            )
          : SizedBox(width: 64, height: 64),
      title: Text("${forecastHour.forecastTime} ${forecastHour.tempF} F"),
      subtitle: Text(
          "$conditionText${forecastHour.chanceOfRain + forecastHour.chanceOfSnow}% chance of precip"),
    );
  }
}
