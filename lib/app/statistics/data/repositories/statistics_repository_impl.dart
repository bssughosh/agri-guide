import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/exceptions.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final String _keyNameTemperature = 'temperature';
  final String _keyNameHumidity = 'humidity';
  final String _keyNameRainfall = 'rainfall';

  static const base_url = String.fromEnvironment(
    'base_url',
    defaultValue: 'https://agri-guide-api.herokuapp.com',
  );

  @override
  Future<StatisticsEntity> fetchWholeData(String state, String district) async {
    List<String> stateName = await _fetchStateNames(state);
    List<String> districtName = await _fetchDistNames(district);

    String url = '$base_url/statistics_data?' +
        'state=${stateName[0]}&' +
        'dist=${districtName[0]}';
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
    List _temperature = data[_keyNameTemperature];
    List _humidity = data[_keyNameHumidity];
    List _rainfall = data[_keyNameRainfall];

    StatisticsEntity statisticsEntity = new StatisticsEntity(
      temperatureData: _temperature,
      humidityData: _humidity,
      rainfallData: _rainfall,
    );

    return statisticsEntity;
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
