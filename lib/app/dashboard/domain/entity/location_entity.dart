import 'package:flutter/foundation.dart';

class LocationEntity {
  final String lat;
  final String lon;
  final String state;
  final String district;

  LocationEntity({
    @required this.lat,
    @required this.lon,
    @required this.state,
    @required this.district,
  });
}
