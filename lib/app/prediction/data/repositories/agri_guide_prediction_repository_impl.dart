import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../../../core/exceptions.dart';
import '../../../accounts/domain/entities/user_entity.dart';
import '../../domain/entities/prediction_data_entity.dart';
import '../../domain/repositories/agri_guide_prediction_repository.dart';

class AgriGuidePredictionRepositoryImpl
    implements AgriGuidePredictionRepository {
  final String _keyNameFullName = 'name';
  final String _keyNameEmail = 'email';
  final String _keyNameAadhar = 'aadhar';
  final String _keyNameState = 'state';
  final String _keyNameDistrict = 'district';
  final String _keyNameMobile = 'mobile';
  final String _keyNameArea = 'area';
  final String _keyNamePincode = 'pincode';
  final String _keyNameTemperature = 'temperature';
  final String _keyNameHumidity = 'humidity';
  final String _keyNameRainfall = 'rainfall';
  final String _keyNameYield = 'yield';

  List<String> temperatue = [];
  List<String> rainfall = [];
  List<String> humidity = [];
  double yieldPrediction = -1.0;
  static const base_url = String.fromEnvironment(
    'base_url',
    defaultValue: 'https://agri-guide-api.herokuapp.com',
  );

  @override
  Future<UserEntity> fetchUserDetails() async {
    final CollectionReference userData =
        FirebaseFirestore.instance.collection('userData');
    User currentSignedInUser = FirebaseAuth.instance.currentUser;
    if (currentSignedInUser == null) throw UserNotSignedInError();
    DocumentSnapshot userDetails =
        await userData.doc(currentSignedInUser.uid).get();
    UserEntity user = new UserEntity(
      aadhar: userDetails[_keyNameAadhar],
      name: userDetails[_keyNameFullName],
      email: userDetails[_keyNameEmail],
      area: userDetails[_keyNameArea],
      state: userDetails[_keyNameState],
      district: userDetails[_keyNameDistrict],
      mobile: userDetails[_keyNameMobile],
      pincode: userDetails[_keyNamePincode],
    );
    return user;
  }

  @override
  Future<PredictionDataEntity> makePrediction(
    String state,
    String district,
    String season,
    String crop,
  ) async {
    List<String> stateName = await _fetchStateNames(state);
    List<String> districtName = await _fetchDistNames(district);
    String url1 = '$base_url/weather?' +
        'state=${stateName[0]}&' +
        'dist=${districtName[0]}';
    http.Response value = await http.get(Uri.parse(url1));
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
    List _temperature = data[_keyNameTemperature];
    List _humidity = data[_keyNameHumidity];
    List _rainfall = data[_keyNameRainfall];
    if (stateName[0] == 'Test' && districtName[0] == 'Test') {
      temperatue.add(_temperature[0].toString());
      humidity.add(_humidity[0].toString());
      rainfall.add(_rainfall[0].toString());
    } else {
      for (int i = 0; i < 12; i++) {
        temperatue.add(_temperature[i].toString());
        humidity.add(_humidity[i].toString());
        rainfall.add(_rainfall[i].toString());
      }
    }

    if (season != '') {
      String url2 = '$base_url/yield?' +
          'state=${stateName[0]}&' +
          'dist=${districtName[0]}&' +
          'season=$season&' +
          'crop=$crop';
      http.Response value = await http.get(Uri.parse(url2));
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
      print(value.statusCode);
      var data = json.decode(value.body);
      List _yield = data[_keyNameYield];
      if (_yield.length == 1) {
        yieldPrediction = _yield[0];
      }
    }

    PredictionDataEntity predictionDataEntity = new PredictionDataEntity(
      temperature: temperatue,
      rainfall: rainfall,
      humidity: humidity,
      predictedYield: yieldPrediction,
    );

    return predictionDataEntity;
  }

  _fetchStateNames(String stateId) async {
    if (stateId == 'Test') {
      return List<String>.from(['Test']);
    }
    String url = '$base_url/get_state_value?state_id=$stateId';
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
    return List<String>.from(data['states']);
  }

  _fetchDistNames(String districtId) async {
    if (districtId == 'Test') {
      return List<String>.from(['Test']);
    }
    String url = '$base_url/get_dist_value?dist_id=$districtId';
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
    return List<String>.from(data['dists']);
  }
}
