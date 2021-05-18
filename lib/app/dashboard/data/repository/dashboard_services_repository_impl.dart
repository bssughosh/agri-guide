import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/exceptions.dart';
import '../../domain/entity/live_weather_entity.dart';
import '../../domain/entity/location_entity.dart';
import '../../domain/repository/dashboard_services_repository.dart';

class DashboardServicesRepositoryImpl extends DashboardServicesRepository {
  /// Unique key name will be [userId]
  Map<String, DateTime> lastFetchedTime = Map();

  /// Unique key name will be [userId]
  Map<String, LocationEntity> locationDetails = Map();

  /// Unique key name will be [userId]
  Map<String, LiveWeatherEntity> liveWeatherDetails = Map();

  /// Unique key name will be [pincode]
  Map<String, DateTime> lastFetchedTimeForNewLocation = Map();

  /// Unique key name will be [pincode]
  Map<String, LocationEntity> locationDetailsForNewLocation = Map();

  /// Unique key name will be [pincode]
  Map<String, LiveWeatherEntity> liveWeatherDetailsForNewLocation = Map();

  final CollectionReference userData =
      FirebaseFirestore.instance.collection('userData');

  final String _keyNameLat = 'lat';
  final String _keyNameLon = 'lon';
  final String _keyNameState = 'state';
  final String _keyNameDistrict = 'district';
  final String _keyNamePincode = 'pincode';
  final String _keyNameTempMax = 'temp_max';
  final String _keyNameHumidity = 'humidity';
  final String _keyNameRain = 'rain';
  final String _keyName3h = '3h';
  final String _keyNameMain = 'main';

  final int weatherDataReloadThresholdInMinutes = 5;

  @override
  Future<void> fetchLatitudeAndLongitude() async {
    if (FirebaseAuth.instance.currentUser == null) {
      throw UserNotSignedInError();
    }

    User currentUser = FirebaseAuth.instance.currentUser!;
    if (locationDetails.containsKey(currentUser.uid)) {
      return;
    }

    DocumentSnapshot<Map<String, dynamic>> userDetails = await (userData
        .doc(currentUser.uid)
        .get() as Future<DocumentSnapshot<Map<String, dynamic>>>);
    if (userDetails.data()!.containsKey(_keyNameLat) &&
        userDetails.data()!.containsKey(_keyNameLon)) {
      locationDetails[currentUser.uid] = new LocationEntity(
        lat: userDetails.data()![_keyNameLat],
        lon: userDetails.data()![_keyNameLon],
        state: capitalize(userDetails.data()![_keyNameState].toString()),
        district: capitalize(userDetails.data()![_keyNameDistrict].toString()),
      );
    } else {
      String _baseUrl = 'https://eu1.locationiq.com';
      String _apiKey = '87b1a8611d97f7';
      String? _pinCode = userDetails.data()![_keyNamePincode];
      String url = '$_baseUrl/v1/search.php?' +
          'key=$_apiKey' +
          '&country=india' +
          '&postalcode=$_pinCode' +
          '&format=json';
      http.Response value = await http.get(Uri.parse(url));
      if (value.statusCode == 400) {
        throw APIBadRequestError();
      } else if (value.statusCode == 403) {
        throw APIForbiddenError();
      } else if (value.statusCode == 404) {
        throw APINotFoundError();
      } else if (value.statusCode == 429) {
        throw APITooManyRequestsError();
      } else if (value.statusCode == 500) {
        throw APIInternalServerError();
      } else if (value.statusCode == 503) {
        throw APIServiceUnavailabeError();
      }
      List data = json.decode(value.body);
      if (data.length > 0) {
        Map<String, dynamic> _jsonResponse = data[0];
        String lat = _jsonResponse[_keyNameLat].toString();
        String lon = _jsonResponse[_keyNameLon].toString();
        try {
          userData.doc(currentUser.uid).update({
            _keyNameLat: lat,
            _keyNameLon: lon,
          });
        } catch (error) {
          throw UserDataUpdationError();
        }

        locationDetails[currentUser.uid] = new LocationEntity(
          lat: lat,
          lon: lon,
          state: capitalize(userDetails.data()![_keyNameState].toString()),
          district:
              capitalize(userDetails.data()![_keyNameDistrict].toString()),
        );
      }
    }

    return;
  }

  @override
  Future<LiveWeatherEntity?> fetchLiveWeather() async {
    if (FirebaseAuth.instance.currentUser == null) {
      throw UserNotSignedInError();
    }

    User currentUser = FirebaseAuth.instance.currentUser!;
    if (liveWeatherDetails.containsKey(currentUser.uid)) {
      if (DateTime.now()
              .difference(lastFetchedTime[currentUser.uid]!)
              .inMinutes <=
          weatherDataReloadThresholdInMinutes) {
        return liveWeatherDetails[currentUser.uid];
      }
    }

    if (!locationDetails.containsKey(currentUser.uid)) {
      await fetchLatitudeAndLongitude();
    }

    String _baseUrl = 'https://api.openweathermap.org';
    String _apiKey = '34e2c047fb1889b5dce88632144fc893';
    String _lat = locationDetails[currentUser.uid]!.lat;
    String _lon = locationDetails[currentUser.uid]!.lon;

    String url = '$_baseUrl/data/2.5/weather?' +
        'lat=$_lat' +
        '&lon=$_lon' +
        '&appid=$_apiKey' +
        '&units=metric';

    http.Response value = await http.get(Uri.parse(url));
    if (value.statusCode == 400) {
      throw APIBadRequestError();
    } else if (value.statusCode == 403) {
      throw APIForbiddenError();
    } else if (value.statusCode == 404) {
      throw APINotFoundError();
    } else if (value.statusCode == 429) {
      throw APITooManyRequestsError();
    } else if (value.statusCode == 500) {
      throw APIInternalServerError();
    } else if (value.statusCode == 503) {
      throw APIServiceUnavailabeError();
    }
    var data = json.decode(value.body);

    if (data.containsKey(_keyNameMain)) {
      num? _temperature = data[_keyNameMain][_keyNameTempMax];
      num? _humidity = data[_keyNameMain][_keyNameHumidity];
      num? _rain = data.containsKey(_keyNameRain)
          ? data[_keyNameRain][_keyName3h]
          : null;

      lastFetchedTime[currentUser.uid] = DateTime.now();

      liveWeatherDetails[currentUser.uid] = new LiveWeatherEntity(
        location: locationDetails[currentUser.uid]!,
        temp: _temperature != null ? _temperature.toString() : "0",
        humidity: _humidity != null ? _humidity.toString() : "0",
        rain: _rain != null ? _rain.toString() : "0",
      );
    } else {
      throw APIResponseFormatError();
    }
    return liveWeatherDetails[currentUser.uid];
  }

  @override
  Future<void> fetchLatitudeAndLongitudeForNewLocation({
    required String? state,
    required String? district,
    required String pincode,
  }) async {
    if (locationDetailsForNewLocation.containsKey(pincode)) {
      return;
    }

    String _baseUrl = 'https://eu1.locationiq.com';
    String _apiKey = '87b1a8611d97f7';
    String url = '$_baseUrl/v1/search.php?' +
        'key=$_apiKey' +
        '&country=india' +
        '&postalcode=$pincode' +
        '&format=json';
    http.Response value = await http.get(Uri.parse(url));
    if (value.statusCode == 400) {
      throw APIBadRequestError();
    } else if (value.statusCode == 403) {
      throw APIForbiddenError();
    } else if (value.statusCode == 404) {
      throw APINotFoundError();
    } else if (value.statusCode == 429) {
      throw APITooManyRequestsError();
    } else if (value.statusCode == 500) {
      throw APIInternalServerError();
    } else if (value.statusCode == 503) {
      throw APIServiceUnavailabeError();
    }
    List data = json.decode(value.body);
    if (data.length > 0) {
      Map<String, dynamic> _jsonResponse = data[0];
      String lat = _jsonResponse[_keyNameLat].toString();
      String lon = _jsonResponse[_keyNameLon].toString();

      locationDetailsForNewLocation[pincode] = new LocationEntity(
        lat: lat,
        lon: lon,
        state: capitalize(state!),
        district: capitalize(district!),
      );
    }

    return;
  }

  @override
  Future<LiveWeatherEntity?> fetchLiveWeatherForNewLocation({
    required String? state,
    required String? district,
    required String pincode,
  }) async {
    if (liveWeatherDetailsForNewLocation.containsKey(pincode)) {
      if (DateTime.now()
              .difference(lastFetchedTimeForNewLocation[pincode]!)
              .inMinutes <=
          weatherDataReloadThresholdInMinutes) {
        return liveWeatherDetailsForNewLocation[pincode];
      }
    }

    if (!locationDetailsForNewLocation.containsKey(pincode)) {
      await fetchLatitudeAndLongitudeForNewLocation(
        pincode: pincode,
        state: state,
        district: district,
      );
    }

    String _baseUrl = 'https://api.openweathermap.org';
    String _apiKey = '34e2c047fb1889b5dce88632144fc893';
    String? _lat = locationDetailsForNewLocation[pincode]!.lat;
    String? _lon = locationDetailsForNewLocation[pincode]!.lon;

    String url = '$_baseUrl/data/2.5/weather?' +
        'lat=$_lat' +
        '&lon=$_lon' +
        '&appid=$_apiKey' +
        '&units=metric';

    http.Response value = await http.get(Uri.parse(url));
    if (value.statusCode == 400) {
      throw APIBadRequestError();
    } else if (value.statusCode == 403) {
      throw APIForbiddenError();
    } else if (value.statusCode == 404) {
      throw APINotFoundError();
    } else if (value.statusCode == 429) {
      throw APITooManyRequestsError();
    } else if (value.statusCode == 500) {
      throw APIInternalServerError();
    } else if (value.statusCode == 503) {
      throw APIServiceUnavailabeError();
    }
    var data = json.decode(value.body);

    if (data.containsKey(_keyNameMain)) {
      num? _temperature = data[_keyNameMain][_keyNameTempMax];
      num? _humidity = data[_keyNameMain][_keyNameHumidity];
      num? _rain = data.containsKey(_keyNameRain)
          ? data[_keyNameRain][_keyName3h]
          : null;

      lastFetchedTimeForNewLocation[pincode] = DateTime.now();

      liveWeatherDetailsForNewLocation[pincode] = new LiveWeatherEntity(
        location: locationDetailsForNewLocation[pincode]!,
        temp: _temperature != null ? _temperature.toString() : "0",
        humidity: _humidity != null ? _humidity.toString() : "0",
        rain: _rain != null ? _rain.toString() : "0",
      );
    } else {
      throw APIResponseFormatError();
    }
    return liveWeatherDetailsForNewLocation[pincode];
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
