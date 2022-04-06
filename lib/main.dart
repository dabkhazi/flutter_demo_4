import 'package:flutter/material.dart';
import 'package:flutter_plain/weather_widjet.dart';

void main() {
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
      home: const SafeArea(child: WeatherForcastPage(cityName: 'Moscow')),
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

  List<Weather> weatherForcast = [
    Weather(DateTime.now(), 20, 90, "04d"),
    Weather(DateTime.now().add(const Duration(hours: 3)), 23, 50, "03d"),
    Weather(DateTime.now().add(const Duration(hours: 6)), 25, 50, "02d"),
    Weather(DateTime.now().add(const Duration(hours: 9)), 28, 50, "01d"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      appBar: AppBar(
        title: const Text('Listview sample'),
      ),
      body: ListView(
        children: weatherForcast.map((e) => WeatherListItem(weather: e)).toList(),
      )  
    );
  }
  
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Text("Flutter plain")       
    );
  }
}