import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/exceptions.dart';
import '../../domain/repositories/fetch_input_repository.dart';

class FetchInputRepositoryImpl implements FetchInputRepository {
  static var httpClient = new HttpClient();
  static const base_url = String.fromEnvironment(
    'base_url',
    defaultValue: 'https://agri-guide-api.herokuapp.com',
  );

  List _stateList;

  /// Key name `stateId`
  Map<String, List> _districtsList = {};

  /// Key name `stateId`
  Map<String, String> _stateNamesMap = {};

  /// Key name `distId`
  Map<String, String> _distNamesMap = {};

  /// Key name `stateId/distId`
  Map<String, List> _cropsList = {};

  /// Key name `stateId/distId/cropId`
  Map<String, List> _seasonsList = {};

  @override
  Future<List> getStateList({bool isTest}) async {
    if (_stateList != null) return _stateList;
    String url = isTest == null
        ? '$base_url/get_states'
        : '$base_url/get_states?isTest=true';
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
    _stateList = data['state'];
    return data['state'];
  }

  @override
  Future<List> getDistrictList(String stateId) async {
    if (_districtsList.containsKey(stateId)) return _districtsList[stateId];
    String url = '$base_url/get_dists?state_id=$stateId';
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
    _districtsList[stateId] = data['district'];
    return data['district'];
  }

  @override
  Future<void> getRequiredDownloads(
    List<String> stateIds,
    List<String> districtIds,
    List<String> years,
    List<String> params,
  ) async {
    List<String> _stateList = await fetchStateNames(stateIds);
    List<String> _districtList = [];
    if (_stateList.length == 1) {
      _districtList = await fetchDistNames(districtIds);
    }

    String states = _stateList.join(',');
    String district = _districtList.join(',');
    String yrs = years.join(',');
    String downloadParams = params.join(',');

    await _launchURL(
        states: states, dists: district, years: yrs, params: downloadParams);
  }

  _launchURL({
    @required String states,
    @required String dists,
    @required String years,
    @required String params,
  }) async {
    String url = "$base_url/agri_guide/downloads?states=" +
        states +
        "&dists=" +
        dists +
        "&years=" +
        years +
        "&params=" +
        params;
    if (await canLaunch(url)) {
      await launch(url);
      print('URL Launcher success');
    } else {
      throw 'Could not launch $url';
    }
  }

  fetchStateNames(List<String> stateIds) async {
    List<String> statesToBeFetched = [];
    for (String state in stateIds) {
      if (!_stateNamesMap.containsKey(state)) {
        statesToBeFetched.add(state);
      }
    }

    if (statesToBeFetched.length == 0) {
      List<String> _res = [];
      for (String state in stateIds) {
        _res.add(_stateNamesMap[state]);
      }

      return _res;
    }

    String formattedStateIds = statesToBeFetched.join(',');
    String url = '$base_url/get_state_value?state_id=$formattedStateIds';
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
    for (int i = 0; i < statesToBeFetched.length; i++) {
      _stateNamesMap[statesToBeFetched[i]] = _output[i];
    }
    List<String> _res = [];
    for (String state in stateIds) {
      _res.add(_stateNamesMap[state]);
    }

    return _res;
  }

  fetchDistNames(List<String> districtIds) async {
    List<String> distsToBeFetched = [];
    for (String district in districtIds) {
      if (!_distNamesMap.containsKey(district)) {
        distsToBeFetched.add(district);
      }
    }

    if (distsToBeFetched.length == 0) {
      List<String> _res = [];
      for (String district in districtIds) {
        _res.add(_distNamesMap[district]);
      }

      return _res;
    }
    String formattedDistIds = distsToBeFetched.join(',');
    String url = '$base_url/get_dist_value?dist_id=$formattedDistIds';
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

    for (int i = 0; i < distsToBeFetched.length; i++) {
      _distNamesMap[distsToBeFetched[i]] = _output[i];
    }
    List<String> _res = [];
    for (String district in districtIds) {
      _res.add(_distNamesMap[district]);
    }

    return _res;
  }

  @override
  Future<List> getCrops(String state, String district) async {
    if (_cropsList.containsKey('$state/$district'))
      return _cropsList['$state/$district'];
    List<String> _stateList;
    List<String> _districtList;
    if (state != 'Test' || district != 'Test') {
      _stateList = await fetchStateNames(List<String>.from([state]));
      _districtList = await fetchDistNames(List<String>.from([district]));
    } else {
      _stateList = ['Test'];
      _districtList = ['Test'];
    }
    String url = '$base_url/get_crops_v2?' +
        'state=${_stateList[0]}&' +
        'dist=${_districtList[0]}';
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
    _cropsList['$state/$district'] = data['crops'];

    return data['crops'];
  }

  @override
  Future<List> getSeasons(String state, String district, String cropId) async {
    if (_seasonsList.containsKey('$state/$district/$cropId'))
      return _seasonsList['$state/$district/$cropId'];
    List<String> _stateList;
    List<String> _districtList;
    if (state != 'Test' || district != 'Test') {
      _stateList = await fetchStateNames(List<String>.from([state]));
      _districtList = await fetchDistNames(List<String>.from([district]));
    } else {
      _stateList = ['Test'];
      _districtList = ['Test'];
    }
    String url = '$base_url/get_seasons_v2?' +
        'state=${_stateList[0]}&' +
        'dist=${_districtList[0]}&' +
        'crop=$cropId';
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
    _seasonsList['$state/$district/$cropId'] = data['seasons'];

    return data['seasons'];
  }

  @override
  Future<void> getRequiredDownloadsMobile(
    List<String> stateIds,
    List<String> districtIds,
    List<String> years,
    List<String> params,
    String fileName,
  ) async {
    List<String> _stateList = await fetchStateNames(stateIds);
    List<String> _districtList = [];
    if (_stateList.length == 1) {
      _districtList = await fetchDistNames(districtIds);
    }

    String states = _stateList.join(',');
    String district = _districtList.join(',');
    String yrs = years.join(',');
    String downloadParams = params.join(',');

    await _downloadFile(
      states: states,
      dists: district,
      years: yrs,
      params: downloadParams,
      fileName: fileName,
    );
  }

  Future<void> _downloadFile({
    @required String states,
    @required String dists,
    @required String years,
    @required String params,
    @required String fileName,
  }) async {
    String url = "$base_url/weather/downloads?states=" +
        states +
        "&dists=" +
        dists +
        "&years=" +
        years +
        "&params=" +
        params;
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getExternalStorageDirectory()).path;
    File file = new File('$dir/$fileName.zip');
    await file.writeAsBytes(bytes);
  }
}
