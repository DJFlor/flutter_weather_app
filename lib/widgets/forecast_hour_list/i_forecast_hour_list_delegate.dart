import 'package:flutter_weather_app/data/models/forecast_hour.dart';

//
// An abstract interface for widgets hosting a ForecastHourList.
//
abstract class IForecastHourListDelegate {
  int forecastHourCount(); // retrieve number of Locations to list
  ForecastHour? forecastHourForIndex(
      int idx); // retrieve location model for index
}
