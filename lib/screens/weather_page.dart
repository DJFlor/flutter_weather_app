import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Model imports;
import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/forecast_hour.dart';
import 'package:flutter_weather_app/data/models/location.dart';
import 'package:flutter_weather_app/data/models/weather_forecast.dart';

// Service imports:
import 'package:flutter_weather_app/data/services/location_search/i_location_search_service.dart';
import 'package:flutter_weather_app/data/services/weather_forecast/i_weather_forecast_service.dart';

// Widget related imports:
import 'package:flutter_weather_app/widgets/current_weather/current_weather_card.dart';
import 'package:flutter_weather_app/widgets/forecast_hour_list/forecast_hour_list.dart';
import 'package:flutter_weather_app/widgets/forecast_hour_list/i_forecast_hour_list_delegate.dart';
import 'package:flutter_weather_app/widgets/location_list/location_list.dart';
import 'package:flutter_weather_app/widgets/location_list/i_location_list_delegate.dart';
import 'package:flutter_weather_app/widgets/location_search_bar/i_location_search_bar_delegate.dart';
import 'package:flutter_weather_app/widgets/location_search_bar/location_search_bar.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    implements
        ILocationListDelegate,
        IForecastHourListDelegate,
        ILocationSearchBarDelegate {
  /* * * * * * * * * * *
   * PAGE LEVEL STATE: *
   * * * * * * * * * * */
  Location? selectedLocation;
  List<Location>? candidateLocations;
  WeatherForecast? weatherForecast;
  bool searching = false;

  /* * * * * * * * * * * * * * * *
   * ILocationSearchBarDelegate: *
   * * * * * * * * * * * * * * * */
  @override
  bool isSearching() => searching;

  @override
  void setSearching(bool newSearching) {
    if (newSearching != searching) {
      setState(() {
        // Set searching flag
        searching = newSearching;
        // Reset candidates and clear search text if not searching:
        if (!searching) {
          candidateLocations = null;
          searchController.clear();
        }
      });
    }
  }

  @override
  void searchStringUpdated(String searchString) {
    // Set the searching status appropriately
    setSearching(searchString != "");
    // Kick off a location search provided we have more than 2 characters:
    if (searchString.length > 2) {
      _fetchCandidateLocationsFor(searchString);
    }
  }

  /* * * * * * * * * * * * * *
   * ILocationListDelegate:  *
   * * * * * * * * * * * * * */
  @override
  void locationSelected(Location location) {
    // A location has been seleced from the search list!
    searchBarFocusNode.unfocus();
    // Set all appropriate state:
    setState(() {
      selectedLocation = location; // stow location
      searchController.clear(); // clear search text
      searching = false; // hide close button
      candidateLocations = null; // clear search list
      weatherForecast = null; // clear weather forecast
    });
    // State has been set, fetch the current condition:
    _fetchWeatherForecastFor(location);
  }

  @override
  int locationCount() {
    return candidateLocations?.length ?? 0;
  }

  @override
  Location? locationForIndex(int idx) {
    return candidateLocations?[idx];
  }

  /* * * * * * * * * * * * * * * *
   * IForecastHourListDelegate:  *
   * * * * * * * * * * * * * * * */
  @override
  int forecastHourCount() {
    return weatherForecast?.todaysForecast.hourlyForecasts.length ?? 0;
  }

  @override
  ForecastHour? forecastHourForIndex(int idx) {
    return weatherForecast?.todaysForecast.hourlyForecasts[idx];
  }

  /* * * * * * * * * * * * * *
   * CONTROLLERS & SERVICES: *
   * * * * * * * * * * * * * */

  // FocusNode handle to the Location Search Bar, so we can
  // clear it when a location is selected:
  final searchBarFocusNode = FocusNode();

  // TextEditingController for managing search textfield:
  final searchController = TextEditingController();

  // Service for querying locations:
  ILocationSearchService get locationSearchService =>
      GetIt.instance<ILocationSearchService>();

  // Service for fetching conditions:
  IWeatherForecastService get weatherForecastService =>
      GetIt.instance<IWeatherForecastService>();

  void _fetchCandidateLocationsFor(String location) async {
    // Fire off the location search service request:
    APIResponse<List<Location>> response =
        await locationSearchService.getLocationList(location);

    if (!response.isError) {
      setState(() {
        // If we are stil searching, update the candidateLocations
        if (searching) {
          candidateLocations = response.data;
        }
      });
    }
  }

  void _fetchWeatherForecastFor(Location location) async {
    // Fire off the current condirtion service request:
    APIResponse<WeatherForecast> response =
        await weatherForecastService.getWeatherForecast(location);

    if (!response.isError) {
      setState(() {
        final currentWeather = response.data?.currentWeather;
        final todaysForecast = response.data?.todaysForecast;
        // If we still have a selectedLocation and solid data, update the weather forecast:
        if (selectedLocation != null &&
            currentWeather != null &&
            todaysForecast != null) {
          // Create a pruned forecast list for only those hours later than the current forecast:
          final List<ForecastHour> newForecastHours = todaysForecast
              .hourlyForecasts
              .where(
                  (hour) => hour.forecastTimeTS > currentWeather.lastUpdatedTS)
              .toList();

          // set the weather forecast with the pruned hourly forecast:
          weatherForecast = WeatherForecast(
              currentWeather: currentWeather,
              todaysForecast:
                  todaysForecast.copyWith(hourlyForecasts: newForecastHours));
        }
      });
    }
  }

  /* * * * * * * * * * *
   * WIDGET OVERRIDES: *
   * * * * * * * * * * */

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
          child: CustomScrollView(
              // The custom scroll view is the performant solution
              // for nesting scrollables.  Our entire page will be scrollable,
              // and will contain other dynammic, scrollable sections,
              // defined statically in the slivers list:
              slivers: [
            // First sliver is the location search app bar:
            SliverPadding(
              padding: EdgeInsets.only(left: 25, right: 25),
              sliver: LocationSearchBar(
                delegate: this,
                searchBarFocusNode: searchBarFocusNode,
                searchController: searchController,
              ),
            ),
            /**
             * Now show a little status pane if we are searching and the text is
             * too short, or we have zero results:
             */
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, idx) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 10, right: 10),
                  child: Text(
                    searchController.text.length < 3
                        ? "Enter at least three characters..."
                        : "No matching locations found.",
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              // If we are searching and the text is too short, or we have no candidates, show a message.
              childCount: searching &&
                      (searchController.text.length < 3 ||
                          (candidateLocations?.length ?? 0) < 1)
                  ? 1
                  : 0,
            )),
            /**
             * Next up is a sliver location list to hold location search results:
             */
            LocationList(delegate: this),
            /**
             * Followed by the CurrentWeatherCard for the location, wrapped
             * in a sliver list so it can just disappear if we have no
             * selected location
             */
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, idx) {
                if (selectedLocation != null) {
                  final loc = selectedLocation!;
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 50, right: 50),
                    child: CurrentWeatherCard(
                      location: loc,
                      currentWeather: weatherForecast?.currentWeather,
                      todaysForecast: weatherForecast?.todaysForecast,
                    ),
                  );
                } else {
                  return null;
                }
              },
              childCount: selectedLocation != null ? 1 : 0,
            )),
            /**
             * Followed by a sliver forecast hour list to hold today's hourly forecast:
             */
            ForecastHourList(delegate: this),
          ])),
    );
  }
}
