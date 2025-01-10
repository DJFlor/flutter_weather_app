import 'package:flutter_weather_app/data/models/location.dart';

//
// An abstract interface for widgets hosting a LocationList.
//
abstract class ILocationListDelegate {
  void locationSelected(Location location); // notify delegate of selection
  int locationCount(); // retrieve number of Locations to list
  Location? locationForIndex(int idx); // retrieve location model for index
}
