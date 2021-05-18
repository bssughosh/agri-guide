import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/exceptions.dart';
import '../../domain/entities/prediction_data_entity.dart';
import '../../domain/repositories/agri_guide_prediction_repository.dart';

class AgriGuidePredictionRepositoryImpl
    implements AgriGuidePredictionRepository {
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

  /// Key name `stateId/distId/cropId/season`
  Map<String, PredictionDataEntity> _predictions = {};

  /// Key name `stateId`
  Map<String?, String> _stateNamesMap = {};

  /// Key name `distId`
  Map<String?, String> _distNamesMap = {};

  @override
  Future<PredictionDataEntity?> makePrediction(
    String? state,
    String? district,
    String? season,
    String? crop,
  ) async {
    if (_predictions.containsKey('$state/$district/$crop/$season')) {
      return _predictions['$state/$district/$crop/$season'];
    }
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
    List? _temperature = data[_keyNameTemperature];
    List? _humidity = data[_keyNameHumidity];
    List? _rainfall = data[_keyNameRainfall];
    if (stateName[0] == 'Test' && districtName[0] == 'Test') {
      temperatue.add(_temperature![0].toString());
      humidity.add(_humidity![0].toString());
      rainfall.add(_rainfall![0].toString());
    } else {
      for (int i = 0; i < 12; i++) {
        temperatue.add(_temperature![i].toString());
        humidity.add(_humidity![i].toString());
        rainfall.add(_rainfall![i].toString());
      }
    }

    if (crop != null) {
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

    _predictions['$state/$district/$crop/$season'] = predictionDataEntity;

    return predictionDataEntity;
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
