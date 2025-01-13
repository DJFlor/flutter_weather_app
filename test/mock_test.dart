import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_app/data/models/location.dart';
import 'package:flutter_weather_app/data/services/current_weather/i_current_weather_service.dart';
import 'package:flutter_weather_app/data/services/location_search/i_location_search_service.dart';
import 'package:flutter_weather_app/data/services/weather_forecast/i_weather_forecast_service.dart';
import 'package:get_it/get_it.dart';

import 'mock_services/mock_current_weather_service.dart';
import 'mock_services/mock_location_search_service.dart';
import 'mock_weather_forecast_service.dart';

void main() {
  // Build mocks with accessible variables to have access to mock controls in tests:
  final MockLocationSearchService mockLocationSearchService =
      MockLocationSearchService();
  final MockCurrentWeatherService mockCurrentWeatherService =
      MockCurrentWeatherService();
  final MockWeatherForecastService mockWeatherForecastService =
      MockWeatherForecastService();

  setUpAll(() {
    // Register MockLocationSearchService for injection as interface type:
    GetIt.instance.registerLazySingleton<ILocationSearchService>(
        () => mockLocationSearchService);
    // Register MockCurrentWeatherService for injection as interface type:
    GetIt.instance.registerLazySingleton<ICurrentWeatherService>(
        () => mockCurrentWeatherService);
    // Register MockWeatherForecastService for injection as interface type:
    GetIt.instance.registerLazySingleton<IWeatherForecastService>(
        () => mockWeatherForecastService);
  });

  group("MockLocationSearchService - ", () {
    final String expectedError = "EXPECTED ERROR";
    final String query = "some query";

    // test error response
    test(
        "GIVEN MockLocationSearchService WHEN errorMessage set THEN response should be error",
        () async {
      // Arrange
      mockLocationSearchService.errorMessage = expectedError;
      // Act
      final response =
          await GetIt.instance<ILocationSearchService>().getLocationList(query);
      // Assert
      expect(response.isError, isTrue,
          reason:
              "WHEN errorMessage is set THEN response.isError should be true.");
      expect(response.errorMessage, equals(expectedError),
          reason:
              "WHEN errorMessage is set THEN response.errorMessage should match.");
      expect(response.data, isNull,
          reason:
              "WHEN errorMessage is set THEN response.data should be null.");
    });

    // test valid response
    test(
        "GIVEN MockLocationSearchService WHEN errorMessage null THEN response should be valid",
        () async {
      // Arrange
      mockLocationSearchService.errorMessage = null;
      // Act
      final response =
          await GetIt.instance<ILocationSearchService>().getLocationList(query);
      // Assert
      expect(response.isError, isFalse,
          reason:
              "WHEN errorMessage is null THEN response.isError should be false.");
      expect(response.errorMessage, isNull,
          reason:
              "WHEN errorMessage is null THEN response.errorMessage should be null.");
      expect(response.data, isNotNull,
          reason:
              "WHEN errorMessage is set THEN response.data should not be null.");
    });
  });

  group("MockCurrentWeatherService - ", () {
    final String expectedError = "EXPECTED ERROR";
    final Location location = Location(
        id: 1,
        name: "A Location",
        region: "A Region",
        country: "A Country",
        lat: 1,
        lon: 1);

    // test error response
    test(
        "GIVEN MockCurrentWeatherService WHEN errorMessage set THEN response should be error",
        () async {
      // Arrange
      mockCurrentWeatherService.errorMessage = expectedError;
      // Act
      final response = await GetIt.instance<ICurrentWeatherService>()
          .getCurrentWeather(location);
      // Assert
      expect(response.isError, isTrue,
          reason:
              "WHEN errorMessage is set THEN response.isError should be true.");
      expect(response.errorMessage, equals(expectedError),
          reason:
              "WHEN errorMessage is set THEN response.errorMessage should match.");
      expect(response.data, isNull,
          reason:
              "WHEN errorMessage is set THEN response.data should be null.");
    });

    // test valid response
    test(
        "GIVEN MockCurrentWeatherService WHEN errorMessage null THEN response should be valid",
        () async {
      // Arrange
      mockCurrentWeatherService.errorMessage = null;
      // Act
      final response = await GetIt.instance<ICurrentWeatherService>()
          .getCurrentWeather(location);
      // Assert
      expect(response.isError, isFalse,
          reason:
              "WHEN errorMessage is null THEN response.isError should be false.");
      expect(response.errorMessage, isNull,
          reason:
              "WHEN errorMessage is null THEN response.errorMessage should be null.");
      expect(response.data, isNotNull,
          reason:
              "WHEN errorMessage is set THEN response.data should not be null.");
    });
  });

  group("MockWeatherForecastSergvice - ", () {
    final String expectedError = "EXPECTED ERROR";
    final Location location = Location(
        id: 1,
        name: "A Location",
        region: "A Region",
        country: "A Country",
        lat: 1,
        lon: 1);

    // test error response
    test(
        "GIVEN MockWeatherForecastSergvice WHEN errorMessage set THEN response should be error",
        () async {
      // Arrange
      mockWeatherForecastService.errorMessage = expectedError;
      // Act
      final response = await GetIt.instance<IWeatherForecastService>()
          .getWeatherForecast(location);
      // Assert
      expect(response.isError, isTrue,
          reason:
              "WHEN errorMessage is set THEN response.isError should be true.");
      expect(response.errorMessage, equals(expectedError),
          reason:
              "WHEN errorMessage is set THEN response.errorMessage should match.");
      expect(response.data, isNull,
          reason:
              "WHEN errorMessage is set THEN response.data should be null.");
    });

    // test valid response
    test(
        "GIVEN MockWeatherForecastSergvice WHEN errorMessage null THEN response should be valid",
        () async {
      // Arrange
      mockWeatherForecastService.errorMessage = null;
      // Act
      final response = await GetIt.instance<IWeatherForecastService>()
          .getWeatherForecast(location);
      // Assert
      expect(response.isError, isFalse,
          reason:
              "WHEN errorMessage is null THEN response.isError should be false.");
      expect(response.errorMessage, isNull,
          reason:
              "WHEN errorMessage is null THEN response.errorMessage should be null.");
      expect(response.data, isNotNull,
          reason:
              "WHEN errorMessage is set THEN response.data should not be null.");
    });
  });
}
