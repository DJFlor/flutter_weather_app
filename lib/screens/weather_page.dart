import 'package:flutter/material.dart';
import 'package:flutter_weather_app/widgets/location_list/i_location_list_delegate.dart';
// import 'package:flutter_weather_app/widgets/location_list/location_list.dart';
import 'package:get_it/get_it.dart';
// import 'package:flutter_weather_app/data/services/current_condition_service.dart';
import 'package:flutter_weather_app/data/services/location_search_service.dart';
import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/location.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    implements ILocationListDelegate {
  // STATE:
  Location? selectedLocation;
  List<Location>? candidateLocations;
  bool searching = false;

  // ILocationListDelegate:
  @override
  void locationSelected(Location location) {
    // A location has been seleced from the search list!
    setState(() {
      selectedLocation = location; // stow location
      searchController.text = ""; // clear search text
      searching = false; // hide close button
      candidateLocations = null; // clear search list
    });
  }

  @override
  int locationCount() {
    return candidateLocations?.length ?? 0;
  }

  @override
  Location? locationForIndex(int idx) {
    return candidateLocations?[idx];
  }

  // Search bar controller for managing searches:
  final searchController = SearchController();

  // Service for querying locations:
  LocationSearchService get locationSearchService =>
      GetIt.instance<LocationSearchService>();

  void _fetchCandidateLocationsFor(String location) async {
    print("WHAT?? $location");
    // Fire off the location search service test:
    APIResponse<List<Location>>? response =
        await locationSearchService.getLocationList(location);

    print("***** RESPONSE: $response");

    if (!response.isError) {
      print("********** GOT ${response.data!.length} locations!");
      setState(() {
        candidateLocations = response.data;
      });
    }
  }

  void setSearching(bool newSearching) {
    if (newSearching != searching) {
      setState(() {
        // Set searching flag
        searching = newSearching;
        // Reset candidates if not searching:
        if (!searching) {
          candidateLocations = null;
          searchController.text = "";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   bottom: SearchAnchor(
      //     builder: (context,searchController),
      //     suggestionsBuilder: suggestionsBuilder),
      // ),
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
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(80),
                        bottomRight: Radius.circular(80))),
                expandedHeight: 90,
                collapsedHeight: 90,
                backgroundColor: Colors.blue,
                titleSpacing: 25,
                title: SearchBar(
                  hintText: "Enter new location",
                  controller: searchController,
                  onChanged: (value) {
                    // toggle searching value appropriately:
                    setSearching(searchController.text != "");
                    // refresh search candidates if we have at least 3 characters:
                    if (searchController.text.length > 2) {
                      _fetchCandidateLocationsFor(value);
                    }
                  },
                  trailing: searching
                      ? [
                          IconButton(
                              onPressed: () {
                                // clear search
                                setSearching(false);
                              },
                              icon: const Icon(Icons.close))
                        ]
                      : null,
                ),
              ),
            ),
            /**
             * Next up is a sliver list to hold location search results:
             */
          ])
          //     child: Column(
          //       // Column is also a layout widget. It takes a list of children and
          //       // arranges them vertically. By default, it sizes itself to fit its
          //       // children horizontally, and tries to be as tall as its parent.
          //       //
          //       // Column has various properties to control how it sizes itself and
          //       // how it positions its children. Here we use mainAxisAlignment to
          //       // center the children vertically; the main axis here is the vertical
          //       // axis because Columns are vertical (the cross axis would be
          //       // horizontal).
          //       //
          //       // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          //       // action in the IDE, or press "p" in the console), to see the
          //       // wireframe for each widget.
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         /**
          //          * I'm choosing to use a SearchBar only here, and not a SearchAnchor
          //          * owing to the fact that the suggestion builder of the anchor is only
          //          * refreshed at the exact instant the text changes.  Our suggestions are
          //          * coming from an asyc source, the WeatherAPI search/autocomplete endpoint,
          //          * and will arrive after the suggestion builder is refreshed.
          //          *
          //          * So instead, we use only a search bar, and a manually implemented
          //          * suggestion pane, so that it might refresh when the suggestions change.
          //          */
          //         SearchBar(
          //           hintText: "Enter new location",
          //           controller: searchController,
          //           onChanged: (value) {
          //             // toggle searching value appropriately:
          //             setSearching(searchController.text != "");
          //             // refresh search candidates if we have at least 3 characters:
          //             if (searchController.text.length > 2) {
          //               _fetchCandidateLocationsFor(value);
          //             }
          //           },
          //           trailing: searching
          //               ? [
          //                   IconButton(
          //                       onPressed: () {
          //                         // clear search
          //                         setSearching(false);
          //                       },
          //                       icon: const Icon(Icons.close))
          //                 ]
          //               : null,
          //         ),
          //         searching // If we are searching....c
          //             ? LocationList(delegate: this)
          //             // ? SizedBox(
          //             //   height: 200,
          //             // )
          //             : SizedBox(
          //                 height: 10,
          //               ),
          //         Placeholder(),
          //       ],
          //     ),
          ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
