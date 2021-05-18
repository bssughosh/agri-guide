import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/exceptions.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/entities/yield_statistics_entity.dart';
import '../../domain/repositories/statistics_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final String _keyNameTemperature = 'temperature';
  final String _keyNameHumidity = 'humidity';
  final String _keyNameRainfall = 'rainfall';
  final String _keyNameYield = 'yield';

  static const base_url = String.fromEnvironment(
    'base_url',
    defaultValue: 'https://agri-guide-api.herokuapp.com',
  );

  /// Key name `stateId`
  Map<String?, String> _stateNamesMap = {};

  /// Key name `distId`
  Map<String?, String> _distNamesMap = {};

  /// Key name `stateId/distId`
  Map<String, StatisticsEntity> _statisticsData = {};

  /// Key name `stateId/distId/cropId/season`
  Map<String, YieldStatisticsEntity> _yieldStatisticsData = {};

  @override
  Future<StatisticsEntity?> fetchWholeData(
      String? state, String? district) async {
    if (_statisticsData.containsKey('$state/$district'))
      return _statisticsData['$state/$district'];
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
    List? _temperature = data[_keyNameTemperature];
    List? _humidity = data[_keyNameHumidity];
    List? _rainfall = data[_keyNameRainfall];

    StatisticsEntity statisticsEntity = new StatisticsEntity(
      temperatureData: _temperature!,
      humidityData: _humidity!,
      rainfallData: _rainfall!,
    );

    _statisticsData['$state/$district'] = statisticsEntity;

    return statisticsEntity;
  }

  @override
  Future<YieldStatisticsEntity?> fetchYieldStatisticsData(
    String? state,
    String? district,
    String? cropId,
    String? season,
  ) async {
    if (_yieldStatisticsData.containsKey('$state/$district/$cropId/$season'))
      return _yieldStatisticsData['$state/$district/$cropId/$season'];
    List<String> stateName = await _fetchStateNames(state);
    List<String> districtName = await _fetchDistNames(district);

    String url = '$base_url/yield-statistics?' +
        'state=${stateName[0]}&' +
        'dist=${districtName[0]}&' +
        'crop=$cropId&' +
        'season=$season';
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
    List? _yield = data[_keyNameYield];

    YieldStatisticsEntity yieldStatisticsEntity =
        new YieldStatisticsEntity(yieldData: _yield!);

    _yieldStatisticsData['$state/$district/$cropId/$season'] =
        yieldStatisticsEntity;

    return yieldStatisticsEntity;
  }

  _fetchStateNames(String? stateId) async {
    if (stateId == 'Test') {
      return List<String>.from(['Test']);
    }
    if (_stateNamesMap.containsKey(stateId)) {
      return List<String>.from([_stateNamesMap[stateId]]);
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
    List<String> _output = List<String>.from(data['states']);

    if (_output.length == 1) {
      _stateNamesMap[stateId] = _output[0];
    } else {
      throw Exception('The output is not proper');
    }

    return _output;
  }

  _fetchDistNames(String? districtId) async {
    if (districtId == 'Test') {
      return List<String>.from(['Test']);
    }
    if (_distNamesMap.containsKey(districtId)) {
      return List<String>.from([_distNamesMap[districtId]]);
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
    List<String> _output = List<String>.from(data['dists']);

    if (_output.length == 1) {
      _distNamesMap[districtId] = _output[0];
    } else {
      throw Exception('The output is not proper');
    }

    return _output;
  }
}
