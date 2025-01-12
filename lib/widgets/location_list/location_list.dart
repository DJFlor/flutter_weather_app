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
    return SliverList(
      // The list slivers will be served via a builder delegate.
      // This allows for dynamically built children.
      delegate: SliverChildBuilderDelegate(
        // The builder method to generate the child tiles:
        (context, idx) {
          // Begin by getting the candate location for the index:
          final loc = delegate.locationForIndex(idx);

          // If we received a Location....
          if (loc != null) {
            // ...return a list tile built from the lcoation:
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: ListTile(
                tileColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(loc.name),
                subtitle: Text("${loc.region}, ${loc.country}"),
                onTap: () {
                  // When tapped, notify the delegate this location has been selected:
                  delegate.locationSelected(loc);
                },
              ),
            );
          } else {
            // Otherwise, ship a null:
            return null;
          }
        },
        // And the child count supplied by the delegate:
        childCount: delegate.locationCount(),
      ),
    );
  }
}
