import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather_app/data/services/current_weather/current_weather_service.dart';
import 'package:flutter_weather_app/data/services/current_weather/i_current_weather_service.dart';
import 'package:flutter_weather_app/data/services/location_search/i_location_search_service.dart';
import 'package:flutter_weather_app/data/services/location_search/location_search_service.dart';
import 'package:flutter_weather_app/data/services/weather_forecast/i_weather_forecast_service.dart';
import 'package:flutter_weather_app/data/services/weather_forecast/weather_forcast_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_weather_app/screens/weather_page.dart';

void registerServices() {
  // Register implementation of IWeatherForecastService:
  GetIt.instance.registerLazySingleton<IWeatherForecastService>(
      () => WeatherForcastService());
  // Register implementation of ICurrentWeatherService:
  GetIt.instance.registerLazySingleton<ICurrentWeatherService>(
      () => CurrentWeatherService());
  // Register implementation of ILocationSearchService:
  GetIt.instance.registerLazySingleton<ILocationSearchService>(
      () => LocationSearchService());
}

void main() {
  registerServices();
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Fix to landscape orientation:
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // Build the app:
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WeatherPage(),
    );
  }
}
