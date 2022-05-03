import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_plain/location_info.dart';
import 'package:flutter_plain/weather_widjet.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'model/forecast_response.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Listview sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SafeArea(child: 
        LocationInheritedWidget(child : WeatherForcastPage(cityName: 'Moscow',))),
    );
  }
}

class WeatherForcastPage extends StatefulWidget {

  final String cityName;

  const WeatherForcastPage({Key? key, required this.cityName}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return _WeatherForcastPageState();
  }
  
}

class _WeatherForcastPageState extends State<WeatherForcastPage> {

  List<ListItem> _weatherForecast = <ListItem>[];

  var _loading = false;

  Position? _location;

  Future<List<ListItem>?> _getWeather(double lat, double lng) async {

    var queryParameters = {
      // подготавливаем параметры запроса
      'APPID': dotenv.env['OPENWEATHER_APIKEY'],
      'units': 'metric',
      'lat': lat.toString(),
      'lon': lng.toString(),
    };

    var uri = Uri.https(Constants.weatherBaseUrl,
        Constants.weatherForecastUrl, queryParameters);
    var response = await http.get(uri); // выполняем запрос и ждем результата

    if (response.statusCode == 200) {
      var forecastResponse =
      ForecastResponse.fromJson(json.decode(response.body));
      if (forecastResponse.cod == "200") {
        // в случае успешного ответа парсим JSON и возвращаем список с прогнозом
        return forecastResponse.list;
      } else {
        // в случае ошибки показываем ошибку
        _displaySnackBar("Error ${forecastResponse.cod}");
      }
    } else {
      // в случае ошибки показываем ошибку
      _displaySnackBar("Error occured while loading data from server");
    }
    return <ListItem>[];
  }

  _refreshWeather(Position location) {
    setState(() {
      _weatherForecast.clear();
      _loading = true;   
    });
    var itCurrentDay = DateTime.now();
    var dataFuture = _getWeather(location.latitude, location.longitude);
    dataFuture.then((val) {
      var weatherForecastLocal = <ListItem>[];
      weatherForecastLocal.add(DayHeading(itCurrentDay)); // first heading
      List<ListItem> weatherData = val!;
      var itNextDay = DateTime.now().add(const Duration(days: 1));
      itNextDay = DateTime(
          itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
      var iterator = weatherData.iterator;
      while (iterator.moveNext()) {
        var weatherDateTime = iterator.current as WheatherList;
        if (weatherDateTime.getDateTime().isAfter(itNextDay)) {
          itCurrentDay = itNextDay;
          itNextDay = itCurrentDay.add(const Duration(days: 1));
          itNextDay = DateTime(
              itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
          weatherForecastLocal.add(DayHeading(itCurrentDay)); // next heading
        } else {
          weatherForecastLocal.add(iterator.current);
        }
      }
      setState(() {
        _loading = false;
        _weatherForecast = weatherForecastLocal;
      });
    });
  }

  Future<void> _loadWeather() async {
    _refreshWeather(_location!); 
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loading = true;
    _location = LocationInfo.of(context).location;
    if (_location != null) {
      _refreshWeather(_location!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      appBar: AppBar(
        title: const Align(alignment: Alignment.centerLeft, child: Text('Weather forecast')),
        actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadWeather,
            ),
          ],
      ),
      body: _loading ? const Center(child: CircularProgressIndicator()) : RefreshIndicator(
        onRefresh: _loadWeather,
        child: ListView.builder(
                  itemCount: _weatherForecast.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = _weatherForecast[index];
                    if (item is WheatherList) {
                      return WeatherListItem(weather: item);
                    } else if (item is DayHeading) {
                      return HeadingListItem(dayHeading: item);
                    } else {
                      throw Exception("wrong type");
                    }
                  }),
      ));
  }

  _displaySnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
}