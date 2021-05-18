import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/enums.dart';
import '../../../core/handle_api_errors.dart';
import '../../../core/observer.dart';
import '../../../injection_container.dart';
import '../../navigation_service.dart';
import 'downloads_presenter.dart';
import 'downloads_state_machine.dart';
import 'widgets/show_dialog.dart';

class DownloadsPageController extends Controller {
  final DownloadsPagePresenter _presenter;
  final DownloadsStateMachine _stateMachine = new DownloadsStateMachine();
  final navigationService = serviceLocator<NavigationService>();

  DownloadsPageController()
      : _presenter = serviceLocator<DownloadsPagePresenter>(),
        super();

  List stateList = [];
  List<String> selectedStates = [];
  List districtList = [];
  List<String> selectedDistricts = [];

  String fromText;
  String toText;

  List<String> years = [];

  List paramsList = [
    {'id': describeEnum(DownloadParams.temp), 'name': 'Temperature'},
    {'id': describeEnum(DownloadParams.humidity), 'name': 'Humidity'},
    {'id': describeEnum(DownloadParams.rainfall), 'name': 'Rainfall'},
    {'id': describeEnum(DownloadParams.yield), 'name': 'Yield'},
  ];

  List<String> selectedParams = [];

  List<String> downloadedFilesToBeDisplayed = [];

  @override
  void initListeners() {}

  @override
  void onInitState() {
    super.onInitState();
    years = createYearsList();
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  DownloadsState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  List<String> createYearsList() {
    List<String> _years = [];
    for (int i = 1901; i < 2019; i++) {
      _years.add(i.toString());
    }

    return _years;
  }

  List<DropdownMenuItem> yearItems() {
    List<DropdownMenuItem> _list = [];
    for (var year in years) {
      _list.add(
        new DropdownMenuItem(
          value: year,
          child: Text(year),
        ),
      );
    }
    return _list;
  }

  void fetchStateList(bool isWeb) {
    _presenter.fetchStateList(
      new UseCaseObserver(
        () {
          print('State list successfully fetched');
        },
        (error) {
          handleAPIErrors(error);
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

  void selectedStateChange() {
    _stateMachine.onEvent(new DownloadsLoadingEvent());
    refreshUI();

    if (selectedStates.length == 1) {
      _presenter.fetchDistrictList(
          new UseCaseObserver(
            () {
              print('District list successfully fetched');
            },
            (error) {
              handleAPIErrors(error);
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

  void selectedParamsChanged() {
    refreshUI();
  }

  void fromYearUpdated(String newYear) {
    fromText = newYear;
    if (fromText == '2019') {
      fromText = '2018';
    }
    if (toText != null && fromText != null) {
      if (int.parse(fromText) >= int.parse(toText)) {
        toText = (int.parse(fromText) + 1).toString();
      }
    }

    refreshUI();
  }

  void toYearUpdated(String newYear) {
    toText = newYear;
    if (toText == '1901') {
      toText = '1902';
    }
    if (toText != null && fromText != null) {
      if (int.parse(fromText) >= int.parse(toText)) {
        fromText = (int.parse(toText) - 1).toString();
      }
    }

    refreshUI();
  }

  void downloadFiles() {
    _stateMachine.onEvent(new DownloadsLoadingEvent());
    refreshUI();

    _presenter.getRequiredDownload(
      new UseCaseObserver(() {
        selectedParams = [];
        selectedStates = [];
        selectedDistricts = [];
        toText = null;
        fromText = null;
        _stateMachine.onEvent(new DownloadsInitializedEvent());
        refreshUI();
      }, (error) {
        handleAPIErrors(error);
        print(error);
      }),
      selectedStates,
      selectedDistricts,
      List<String>.from([fromText, toText]),
      selectedParams,
    );
  }

  void downloadFilesMobile({@required BuildContext context}) {
    _stateMachine.onEvent(new DownloadsLoadingEvent());
    refreshUI();

    String fileName = _createTimeStamp();
    _presenter.getRequiredDownloadMobile(
      new UseCaseObserver(() async {
        await checkDownloadedFiles();
        selectedParams = [];
        selectedStates = [];
        selectedDistricts = [];
        toText = null;
        fromText = null;
        _stateMachine.onEvent(new DownloadsInitializedEvent());
        refreshUI();
        Fluttertoast.showToast(
          msg:
              'The file is downloaded at location => Android/data/com.agri_guide/$fileName.zip',
          toastLength: Toast.LENGTH_LONG,
        );
        showMyDialog(context: context);
      }, (error) {
        handleAPIErrors(error);
        print(error);
      }),
      selectedStates,
      selectedDistricts,
      List<String>.from([fromText, toText]),
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
    String _currentSecond = currentDateTime.second.toString();

    String _fileName = _currentYear +
        _currentMonth +
        _currentDay +
        _currentHour +
        _currentMinute +
        _currentSecond;

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
          .add('$_toBeAdded${_pathElements[_pathElements.length - 1]}');
    }
  }

  void updateStateList(List<String> newStateList) {
    selectedStates = newStateList;
    districtList = [];
    selectedDistricts = [];
    fromText = null;
    toText = null;
    selectedStateChange();
    refreshUI();
  }

  void updateDistrictList(List<String> newDistrictList) {
    selectedDistricts = newDistrictList;
    refreshUI();
  }
}
