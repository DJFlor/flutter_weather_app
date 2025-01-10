import 'package:flutter/material.dart';
import 'package:flutter_weather_app/widgets/location_list/i_location_list_delegate.dart';

class LocationList extends StatelessWidget {
  final ILocationListDelegate delegate;

  const LocationList({
    super.key,
    required this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: delegate.locationCount(),
      itemBuilder: (BuildContext context, int idx) {
        // Fetch the location for the index from the delegate:
        final location = delegate.locationForIndex(idx);
        // If we have a non-null location...
        if (location != null) {
          // Build a tile for the location:
          return ListTile(
            onTap: () {
              // On tap, we notify the delegate this location was selected:
              delegate.locationSelected(location);
            },
            title: Text(location.name),
            subtitle: Text("${location.region}, ${location.country}"),
          );
        }
        // No location for this index, no tile!
        return null;
      },
    );
  }
}
