import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gps_tracker/location_service.dart';
import 'package:gps_tracker/user_location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Background Service',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BackGroundService(),
    );
  }
}

class BackGroundService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BackGroundServiceState();
  }
}

class BackGroundServiceState extends State<BackGroundService> {
  int START_SERVICE = 0;
  LocationService locationService = LocationService();
  double? latitude = 0;
  double? longitude = 0;

  Future<void> startService() async {
    if (Platform.isAndroid) {
      locationService.getlocationuser = true;
      locationService.locationStream.listen((UserLocation) {
        setState(() {
          latitude = UserLocation.latitude;
          longitude = UserLocation.longitude;
        });
      });

      var methodChannel = MethodChannel("com.example.messages");
      String data = await methodChannel.invokeMethod("startService");

      debugPrint(data);
    }
  }

  Future<void> stopService() async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("com.example.messages");
      String data = await methodChannel.invokeMethod("stopService");
      locationService.getlocationuser = false;

      dispose();

      debugPrint(data);
    }
  }

  @override
  void dispose() {
    locationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('${latitude}'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {
            if (START_SERVICE == 0) {
              startService();
              setState(() {
                START_SERVICE = 1;
              });
            } else {
              stopService();
              setState(() {
                START_SERVICE = 0;
              });
            }
          },
          color: Colors.brown,
          child: Text(
            (START_SERVICE == 0) ? "Start Service" : "Stop Service",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
