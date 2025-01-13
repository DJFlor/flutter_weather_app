import 'package:flutter/material.dart';
import 'package:flutter_weather_app/widgets/current_weather/current_weather_card.dart';
import 'package:get_it/get_it.dart';

// Model imports;
import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/location.dart';
import 'package:flutter_weather_app/data/models/weather_forecast.dart';

// Service imports:
import 'package:flutter_weather_app/data/services/location_search/i_location_search_service.dart';
import 'package:flutter_weather_app/data/services/weather_forecast/i_weather_forecast_service.dart';

// Widget related imports:
import 'package:flutter_weather_app/widgets/location_list/location_list.dart';
import 'package:flutter_weather_app/widgets/location_list/i_location_list_delegate.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    implements ILocationListDelegate {
  /* * * * * * * * * * *
   * PAGE LEVEL STATE: *
   * * * * * * * * * * */
  Location? selectedLocation;
  List<Location>? candidateLocations;
  WeatherForecast? weatherForecast;
  bool searching = false;

  // Utility method to cascadse searching state:
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

  /* * * * * * * * * * * * * *
   * ILocationListDelegate:  *
   * * * * * * * * * * * * * */
  @override
  void locationSelected(Location location) {
    // A location has been seleced from the search list!
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

  /* * * * * * * * * * * * * *
   * CONTROLLERS & SERVICES: *
   * * * * * * * * * * * * * */

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

    // print("***** RESPONSE: $response");

    if (!response.isError) {
      // print("********** GOT ${response.data!.length} locations!");
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

    // print("***** RESPONSE: $response");

    if (!response.isError) {
      // print("********** GOT current condition!");
      setState(() {
        // If we still have a selectedLocation, update the currentCondition:
        if (selectedLocation != null && response.data != null) {
          weatherForecast = response.data;
        }
      });
    }
    // else {
    //   print("********** GOT error: ${response.errorMessage}");
    // }
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
            // First sliver is the app bar, which contains the search field:
            SliverPadding(
              padding: EdgeInsets.only(left: 25, right: 25),
              sliver: SliverAppBar(
                pinned: true,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(80),
                        bottomRight: Radius.circular(80))),
                expandedHeight: 90,
                collapsedHeight: 90,
                backgroundColor: theme.primaryColor,
                titleSpacing: 25,
                /**
                 * 
                 * I'm choosing to use a TextField only here, and not a SearchAnchor
                 * owing to the fact that the suggestion builder of the anchor is only
                 * refreshed at the exact instant the text changes.  Our suggestions are
                 * coming from an asyc source, the WeatherAPI search/autocomplete endpoint,
                 * and will arrive after the suggestion builder is refreshed. 
                 * 
                 * The accepted work-around is to insert zero-width unicode spaces into the 
                 * search string to affect a refresh, but I do not like sullying the data
                 * that way, as downstreamm issues may arise, requiring us to prune the 
                 * zero-width spaces, and that is too much squeeze for not enough juice.
                 * 
                 * It is bewtter to keep the data clean, and not play such games.
                 * 
                 * Also, the SearchBar enforces spell checking, and we don't want that for
                 * this.  Full stop.  With TextField, we can turn it off.
                 *
                 * So instead, we use only a TextField, and a manually implemented
                 * suggestion list, so that it might refresh when the suggestions change.
                 *
                 */

                title: TextField(
                  enableSuggestions: false,
                  spellCheckConfiguration: SpellCheckConfiguration.disabled(),
                  controller: searchController,
                  // Handler called whenever the text changes:
                  onChanged: (value) {
                    // toggle searching value appropriately:
                    setSearching(searchController.text != "");
                    // refresh search candidates if we have at least 3 characters:
                    if (searchController.text.length > 2) {
                      _fetchCandidateLocationsFor(value);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    filled: true,
                    hintText: 'Enter new location',
                    contentPadding: EdgeInsets.all(20),
                    /**
                     * The suffix icon, when searching, is a "close" style
                     * icon button that clears the search.  When not searching,
                     * the trailing icon is a vanilla search icon.
                     */
                    suffixIcon: searching
                        ? IconButton(
                            onPressed: () {
                              // clear search
                              setSearching(false);
                            },
                            icon: const Icon(Icons.close))
                        : const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            /**
             * Next up is a sliver location list to hold location search results:
             */
            LocationList(delegate: this),
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
          ])),
    );
  }
}
