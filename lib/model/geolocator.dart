import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

//
// v2.0 - 29/09/2020
//

class Location {
  Geolocator _geolocator = Geolocator();
  Position _currentPosition;

  Future<Position> getCurrent() async {
    _currentPosition = await _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .timeout(Duration(seconds: 10), onTimeout: () async {
      return await _geolocator.getLastKnownPosition().timeout(Duration(seconds: 10));
    });
    return _currentPosition;
  }

  distance(double lat, double lng) async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.location]);

    var _distanceInMeters = -1.0;

    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
      if (_currentPosition == null)
        await getCurrent();

      _distanceInMeters = await _geolocator.distanceBetween(
              _currentPosition.latitude, _currentPosition.longitude,
              lat, lng);
    }
    return _distanceInMeters;
  }

  distanceBetween(double lat, double lng, double lat2, double lng2) async {
    var _distanceInMeters = -1.0;
    _distanceInMeters = await _geolocator.distanceBetween(
        lat2, lng2,
        lat, lng);
    return _distanceInMeters;
  }
}