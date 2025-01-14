import 'package:flutter/material.dart';
import 'package:flutter_weather_app/widgets/forecast_hour_list/forecast_hour_list_tile.dart';
import 'package:flutter_weather_app/widgets/forecast_hour_list/i_forecast_hour_list_delegate.dart';

class ForecastHourList extends StatelessWidget {
  final IForecastHourListDelegate delegate;

  const ForecastHourList({
    super.key,
    required this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      // The list slivers will be served via a builder delegate.
      // This allows for dynamically built children.
      delegate: SliverChildBuilderDelegate(
        // The builder method to generate the child tiles:
        (context, idx) {
          // Begin by getting the forecast hour for the index:
          final forecastHour = delegate.forecastHourForIndex(idx);

          // If we received a Location....
          if (forecastHour != null) {
            // ...return a list tile built from the lcoation:
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: ForecastHourListTile(forecastHour: forecastHour),
            );
          } else {
            // Otherwise, ship a null:
            return null;
          }
        },
        // And the child count supplied by the delegate:
        childCount: delegate.forecastHourCount(),
      ),
    );
  }
}
