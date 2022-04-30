
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/forecast_response.dart';

abstract class ListItemWidget {}

class WeatherListItem extends StatelessWidget implements ListItemWidget {
  static final _dateFormat = DateFormat('HH:mm');
  final WheatherList weather;

  const WeatherListItem({Key? key, required this.weather}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var temp = weather.main!.temp;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: 
              Text(_dateFormat.format(weather.getDateTime()), style: Theme.of(context).textTheme.subtitle1)
          ),
          Text((temp).toString() + ' \u00B0C', style: Theme.of(context).textTheme.subtitle1),
          Image.network(weather.getIconUrl()),
        ],
      ),
    );
  }
}

// class Weather extends ListItem {
//   static const String weatherURL = "http://openweathermap.org/img/w/";

//   DateTime dateTime;
//   num degree;
//   int clouds;
//   String iconURL;

//   String getIconUrl() {
//     return weatherURL + iconURL + ".png";
//   }

//   Weather(this.dateTime, this.degree, this.clouds, this.iconURL);
// }

class DayHeading extends ListItem {
  final DateTime dateTime;

  DayHeading(this.dateTime);
}

class HeadingListItem extends StatelessWidget implements ListItemWidget {

  static final _dateFormatWeekDay = DateFormat('EEEE');
  static final _dateFormatDay = DateFormat('MMMMd');

  final DayHeading dayHeading;
  
  const HeadingListItem({ Key? key, required this.dayHeading }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(children: [
        Text(
          _dateFormatWeekDay.format(dayHeading.dateTime) + ', ' + _dateFormatDay.format(dayHeading.dateTime),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Divider()
      ]),      
    );
  }

}