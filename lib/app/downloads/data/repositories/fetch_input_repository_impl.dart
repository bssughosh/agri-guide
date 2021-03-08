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

  @override
  Future<List> getStateList({bool isTest}) async {
    String url = isTest == null
        ? '$base_url/get_states'
        : '$base_url/get_states?isTest=true';
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
    var data = json.decode(value.body);
    return data['state'];
  }

  @override
  Future<List> getDistrictList(String stateId) async {
    String url = '$base_url/get_dists?state_id=$stateId';
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
    var data = json.decode(value.body);
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
    String formattedStateIds = stateIds.join(',');
    String url = '$base_url/get_state_value?state_id=$formattedStateIds';
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
    var data = json.decode(value.body);
    return List<String>.from(data['states']);
  }

  fetchDistNames(List<String> districtIds) async {
    String formattedDistIds = districtIds.join(',');
    String url = '$base_url/get_dist_value?dist_id=$formattedDistIds';
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
    var data = json.decode(value.body);
    return List<String>.from(data['dists']);
  }

  @override
  Future<List> getSeasons(String state, String district) async {
    List<String> _stateList;
    List<String> _districtList;
    if (state != 'Test' || district != 'Test') {
      _stateList = await fetchStateNames(List<String>.from([state]));
      _districtList = await fetchDistNames(List<String>.from([district]));
    } else {
      _stateList = ['Test'];
      _districtList = ['Test'];
    }
    String url =
        '$base_url/get_seasons?state=${_stateList[0]}&dist=${_districtList[0]}';
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
    var data = json.decode(value.body);
    return data['seasons'];
  }

  @override
  Future<List> getCrops(String state, String district, String season) async {
    List<String> _stateList;
    List<String> _districtList;
    if (state != 'Test' || district != 'Test') {
      _stateList = await fetchStateNames(List<String>.from([state]));
      _districtList = await fetchDistNames(List<String>.from([district]));
    } else {
      _stateList = ['Test'];
      _districtList = ['Test'];
    }
    String url = '$base_url/get_crops?' +
        'state=${_stateList[0]}&' +
        'dist=${_districtList[0]}&' +
        'season=$season';
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
    var data = json.decode(value.body);
    return data['crops'];
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
