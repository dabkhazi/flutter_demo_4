import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class LocationInfo extends InheritedWidget{

  Position? location;

  LocationInfo(this.location, {Key? key, required Widget child}) : super(key: key, child: child);

  static LocationInfo of(BuildContext context) => 
    context.dependOnInheritedWidgetOfExactType<LocationInfo>()!;

  @override
  bool updateShouldNotify(LocationInfo oldWidget) {

    var oldLocationTime = oldWidget.location?.timestamp?.millisecondsSinceEpoch ?? 0;

    var newLocationTime = location?.timestamp?.millisecondsSinceEpoch ?? 0;

    if (oldLocationTime == 0 && newLocationTime == 0) {
      // для случая первой загрузки
      return true;
    }

    return oldLocationTime < newLocationTime;
  }
  
}

class LocationInheritedWidget extends StatefulWidget {

  final Widget child;

  const LocationInheritedWidget({ Key? key, required this.child }) : super(key: key);

  @override
  State<LocationInheritedWidget> createState() => _LocationInheritedWidgetState();
}

class _LocationInheritedWidgetState extends State<LocationInheritedWidget> {

  Position? _location;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  }

  @override
  void initState() {
    super.initState();
    var locationFuture = _determinePosition();
    locationFuture.then((newLocation) {
        setState(() {
          _location = newLocation;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  LocationInfo(_location, child: widget.child);
  }
}