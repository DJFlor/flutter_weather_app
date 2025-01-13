import 'package:flutter/material.dart';
import 'package:flutter_weather_app/data/models/location.dart';
import 'package:flutter_weather_app/widgets/location_list/i_location_list_delegate.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.loc,
    required this.delegate,
  });

  final Location loc;
  final ILocationListDelegate delegate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = TextStyle(
      color: theme.primaryColorDark,
    );

    return ListTile(
      tileColor: theme.primaryColorLight,
      titleTextStyle: style,
      subtitleTextStyle: style,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(loc.name),
      subtitle: Text("${loc.region}, ${loc.country}"),
      onTap: () {
        // When tapped, notify the delegate this location has been selected:
        delegate.locationSelected(loc);
      },
    );
  }
}
