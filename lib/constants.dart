  import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String weatherBaseScheme = 'https://';
  static const String weatherBaseUrl = 'api.openweathermap.org';
  static const String weatherImagesPath = "/img/w/";
  static const String weatherImagesUrl =
      weatherBaseScheme + weatherBaseUrl + weatherImagesPath;
  static const String weatherForecastUrl = "/data/2.5/forecast";
}