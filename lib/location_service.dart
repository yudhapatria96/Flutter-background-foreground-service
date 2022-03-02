import 'dart:async';

import 'package:gps_tracker/user_location.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = new Location();
  StreamController<UserLocation> _locationStreamController =
      StreamController<UserLocation>.broadcast();
  Stream<UserLocation> get locationStream => _locationStreamController.stream;
  bool getlocationuser = true;
  LocationService() {
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            if (getlocationuser == true) {
              _locationStreamController.add(UserLocation(
                  latitude: locationData.latitude,
                  longitude: locationData.longitude));
            }
          }
        });
      }
    });
  }
  void dispose() {
    _locationStreamController.close();
  }
}
