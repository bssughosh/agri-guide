import 'package:flutter/foundation.dart';

import 'location_entity.dart';

class LiveWeatherEntity {
  final LocationEntity location;
  final String rain;
  final String temp;
  final String humidity;

  LiveWeatherEntity({
    @required this.location,
    @required this.rain,
    @required this.temp,
    @required this.humidity,
  });
}
