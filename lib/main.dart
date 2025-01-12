import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_weather_app/screens/weather_page.dart';
import 'package:flutter_weather_app/data/services/weather_forcast_service.dart';
// import 'package:flutter_weather_app/data/services/current_weather_service.dart';
import 'package:flutter_weather_app/data/services/location_search_service.dart';

void registerServices() {
  GetIt.instance.registerLazySingleton(() => WeatherForcastService());
  // GetIt.instance.registerLazySingleton(() => CurrentWeatherService());
  GetIt.instance.registerLazySingleton(() => LocationSearchService());
}

void main() {
  registerServices();
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
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
