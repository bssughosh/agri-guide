import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/exceptions.dart';
import '../../../core/observer.dart';
import '../../../injection_container.dart';
import 'downloads_presenter.dart';
import 'downloads_state_machine.dart';

class DownloadsPageController extends Controller {
  final DownloadsPagePresenter _presenter;
  final DownloadsStateMachine _stateMachine = new DownloadsStateMachine();

  DownloadsPageController()
      : _presenter = serviceLocator<DownloadsPagePresenter>(),
        super();

  List stateList = [];
  List<String> selectedStates = [];
  List districtList = [];
  List<String> selectedDistricts = [];
  bool isStateFilterClicked = false;
  bool isDistrictFilterClicked = false;
  TextEditingController fromText = new TextEditingController();
  TextEditingController toText = new TextEditingController();
  List paramsList = [
    {'id': describeEnum(DownloadParams.temp), 'name': 'Temperature'},
    {'id': describeEnum(DownloadParams.humidity), 'name': 'Humidity'},
    {'id': describeEnum(DownloadParams.rainfall), 'name': 'Rainfall'}
  ];
  List<String> selectedParams = [
    describeEnum(DownloadParams.temp),
    describeEnum(DownloadParams.humidity),
    describeEnum(DownloadParams.rainfall),
  ];
  bool isParamsFilterClicked = false;
  bool isDownloading = false;

  List<String> downloadedFilesToBeDisplayed = [];

  @override
  void initListeners() {}

  @override
  dispose() {
    _presenter.dispose();
    super.dispose();
  }

  DownloadsState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void fetchStateList(bool isWeb) {
    _presenter.fetchStateList(
      new UseCaseObserver(
        () {
          print('State list successfully fetched');
        },
        (error) {
          _handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List stateListRes) async {
          stateList = stateListRes;
          if (!isWeb) await checkDownloadedFiles();
          _stateMachine.onEvent(new DownloadsInitializedEvent());
          refreshUI();
        },
      ),
    );
  }

  _handleAPIErrors(Exception error) {
    if (error.runtimeType == APIBadRequestError) {
      Fluttertoast.showToast(
          msg: 'A bad request was encountered. Please try again');
    } else if (error.runtimeType == APIForbiddenError) {
      Fluttertoast.showToast(
          msg: 'The request was forbidden. Please try again');
    } else if (error.runtimeType == APINotFoundError) {
      Fluttertoast.showToast(
          msg:
              'The request was incorrect. Please check the request and try again');
    } else if (error.runtimeType == APITooManyRequestsError) {
      Fluttertoast.showToast(
          msg:
              'There are too many requests serviced right now. Please try again after sometime');
    } else if (error.runtimeType == APIInternalServerError) {
      Fluttertoast.showToast(
          msg:
              'There was an internal server error. Please try again after sometime');
    } else if (error.runtimeType == APIServiceUnavailabeError) {
      Fluttertoast.showToast(
          msg:
              'The server is under maintenance right now. Please try again after sometime');
    } else {
      Fluttertoast.showToast(
          msg:
              'The request was incorrect. Please check the request and try again');
    }
  }

  void handleStateFilterClicked() {
    if (isDistrictFilterClicked || isParamsFilterClicked) {
    } else {
      isStateFilterClicked = !isStateFilterClicked;
    }
    refreshUI();
  }

  void handleDistrictFilterClicked() {
    if (isStateFilterClicked || isParamsFilterClicked) {
    } else {
      isDistrictFilterClicked = !isDistrictFilterClicked;
    }
    refreshUI();
  }

  void handleParamsFilterClicked() {
    if (isStateFilterClicked || isDistrictFilterClicked) {
    } else {
      isParamsFilterClicked = !isParamsFilterClicked;
    }
    refreshUI();
  }

  void handleCheckBoxChangeOfState(bool value, String id) {
    if (value) {
      selectedStates.add(id);
    } else {
      selectedStates.remove(id);
    }
    refreshUI();
  }

  void handleCheckBoxChangeOfDistrict(bool value, String id) {
    if (value) {
      selectedDistricts.add(id);
    } else {
      selectedDistricts.remove(id);
    }
    refreshUI();
  }

  void handleCheckBoxChangeOfParams(bool value, String id) {
    if (value) {
      selectedParams.add(id);
    } else {
      selectedParams.remove(id);
    }
    refreshUI();
  }

  void selectedStateChange() {
    _stateMachine.onEvent(new DownloadsInitializationEvent(false));
    refreshUI();

    if (selectedStates.length == 1) {
      _presenter.fetchDistrictList(
          new UseCaseObserver(
            () {
              print('District list successfully fetched');
            },
            (error) {
              _handleAPIErrors(error);
              print(error);
            },
            onNextFunction: (List districtListRes) {
              districtList = districtListRes;
              _stateMachine.onEvent(new DownloadsInitializedEvent());
              refreshUI();
            },
          ),
          selectedStates[0]);
    } else {
      _stateMachine.onEvent(new DownloadsInitializedEvent());
      refreshUI();
    }
  }

  void selectedDistrictChanged() {
    refreshUI();
  }

  void selectedParamsChanged() {
    refreshUI();
  }

  void updateRangeYear(String newValue, bool isFrom) {
    if (newValue != '') {
      if (isFrom)
        fromText.text = newValue;
      else
        toText.text = newValue;
    }
    refreshUI();
  }

  void downloadFiles() {
    _presenter.getRequiredDownload(
      new UseCaseObserver(() {}, (error) {
        _handleAPIErrors(error);
        print(error);
      }),
      selectedStates,
      selectedDistricts,
      List<String>.from([fromText.text, toText.text]),
      selectedParams,
    );
  }

  void downloadFilesMobile() {
    isDownloading = true;
    refreshUI();
    String fileName = _createTimeStamp();
    _presenter.getRequiredDownloadMobile(
      new UseCaseObserver(() async {
        isDownloading = false;
        await checkDownloadedFiles();
        refreshUI();
        Fluttertoast.showToast(
          msg:
              'The file is downloaded at location => Android/data/com.agri_guide/$fileName.zip',
          toastLength: Toast.LENGTH_LONG,
        );
      }, (error) {
        _handleAPIErrors(error);
        print(error);
      }),
      selectedStates,
      selectedDistricts,
      List<String>.from([fromText.text, toText.text]),
      selectedParams,
      fileName,
    );
  }

  _createTimeStamp() {
    DateTime currentDateTime = DateTime.now();
    String _currentYear = currentDateTime.year.toString();
    String _currentMonth = currentDateTime.month.toString();
    String _currentDay = currentDateTime.day.toString();
    String _currentHour = currentDateTime.hour.toString();
    String _currentMinute = currentDateTime.minute.toString();

    String _fileName = _currentYear +
        _currentMonth +
        _currentDay +
        _currentHour +
        _currentMinute;

    return _fileName;
  }

  bool onWillPopScope() {
    if (selectedDistricts.length != 0) {
      selectedDistricts = [];
    } else if (selectedStates.length != 0) {
      selectedStates = [];
      selectedDistricts = [];
      districtList = [];
    }
    refreshUI();

    return false;
  }

  Future<void> checkDownloadedFiles() async {
    Directory downloadsDirectory = await getExternalStorageDirectory();
    List<FileSystemEntity> _downloads =
        await downloadsDirectory.list(recursive: true).toList();
    downloadedFilesToBeDisplayed = [];
    for (FileSystemEntity _downloadFile in _downloads) {
      String _path = _downloadFile.path.toString();
      List<String> _pathElements = _path.split('/');
      String _toBeAdded = 'Android/data/com.agri_guide/files/';
      downloadedFilesToBeDisplayed
          .add(_toBeAdded + _pathElements[_pathElements.length - 1]);
    }
  }
}

enum SelectionListType {
  STATE,
  DISTRICT,
}

enum DownloadParams {
  temp,
  humidity,
  rainfall,
}
