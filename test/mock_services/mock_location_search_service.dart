import 'package:flutter_weather_app/data/models/a_p_i_response.dart';
import 'package:flutter_weather_app/data/models/location.dart';
import 'package:flutter_weather_app/data/services/location_search/i_location_search_service.dart';

class MockLocationSearchService implements ILocationSearchService {
  /// the number of ms to delay the return
  int latency;

  /// optional errorMessage, triggers error response
  String? errorMessage;

  MockLocationSearchService({
    this.latency = 0, // default 0ms delay
    this.errorMessage, // default null
  });

  @override
  Future<APIResponse<List<Location>>> getLocationList(String location) =>
      Future(() async {
        // delay if apropriate
        if (latency > 0) {
          await Future.delayed(Duration(milliseconds: latency));
        }
        // formulate response
        return APIResponse(
          // data is populated if errorMessage is null
          data: errorMessage != null
              ? null
              : [
                  Location(
                      id: 1,
                      name: "A Location",
                      region: "A Region",
                      country: "A Country",
                      lat: 1,
                      lon: 1),
                  Location(
                      id: 2,
                      name: "B Location",
                      region: "B Region",
                      country: "B Country",
                      lat: 2,
                      lon: 2),
                  Location(
                      id: 3,
                      name: "C Location",
                      region: "C Region",
                      country: "C Country",
                      lat: 3,
                      lon: 3),
                ],
          isError: errorMessage != null,
          errorMessage: errorMessage,
        );
      });
}
