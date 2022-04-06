
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherListItem extends StatelessWidget {
  static final _dateFormat = DateFormat('yyyy-MM-dd - hh:m');
  final Weather weather;

  const WeatherListItem({Key? key, required this.weather}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(_dateFormat.format(weather.dateTime))
          ),
          Expanded(
            flex: 1,
            child: Text(weather.degree.toString() + ' C')
          ),
          Expanded(
            flex: 1,
            child: Image.network(weather.getIconUrl())
          ),
        ],
      ),
    );
  }
}

class Weather  {
  static const String weatherURL = "http://openweathermap.org/img/w/";

  DateTime dateTime;
  num degree;
  int clouds;
  String iconURL;

  String getIconUrl() {
    return weatherURL + iconURL + ".png";
  }

  Weather(this.dateTime, this.degree, this.clouds, this.iconURL);
}