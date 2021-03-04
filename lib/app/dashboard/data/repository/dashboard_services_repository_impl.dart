import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final CollectionReference userData =
      FirebaseFirestore.instance.collection('userData');

  final String _keyNameLat = 'lat';
  final String _keyNameLon = 'lon';
  final String _keyNameState = 'state';
  final String _keyNameDistrict = 'district';
  final String _keyNamePincode = 'pincode';

  @override
  Future<LocationEntity> fetchLatitudeAndLongitude() async {
    if (FirebaseAuth.instance.currentUser == null) {
      throw UserNotSignedInError();
    }

    User currentUser = FirebaseAuth.instance.currentUser;
    if (locationDetails.containsKey(currentUser.uid)) {
      return locationDetails[currentUser.uid];
    }

    DocumentSnapshot userDetails = await userData.doc(currentUser.uid).get();
    if (userDetails.data().containsKey(_keyNameLat) &&
        userDetails.data().containsKey(_keyNameLon)) {
      locationDetails[currentUser.uid] = new LocationEntity(
        lat: userDetails.data()[_keyNameLat],
        lon: userDetails.data()[_keyNameLon],
        state: userDetails.data()[_keyNameState],
        district: userDetails.data()[_keyNameDistrict],
      );
    } else {
      String _baseUrl = 'https://eu1.locationiq.com';
      String _apiKey = '87b1a8611d97f7';
      String _pinCode = userDetails.data()[_keyNamePincode];
      String url = '$_baseUrl/v1/search.php?' +
          'key=$_apiKey' +
          '&country=india' +
          '&postalcode=$_pinCode' +
          '&format=json';
      http.Response value = await http.get(url);
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

        userData.doc(currentUser.uid).update({
          _keyNameLat: lat,
          _keyNameLon: lon,
        });

        locationDetails[currentUser.uid] = new LocationEntity(
          lat: lat,
          lon: lon,
          state: userDetails.data()[_keyNameState],
          district: userDetails.data()[_keyNameDistrict],
        );
      }
    }

    return locationDetails[currentUser.uid];
  }

  @override
  Future<LiveWeatherEntity> fetchLiveWeather() {
    // TODO: implement fetchLiveWeather
    throw UnimplementedError();
  }
}
