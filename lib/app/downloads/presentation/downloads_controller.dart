import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/exceptions.dart';
import '../../../core/observer.dart';
import '../../../injection_container.dart';
import '../../navigation_service.dart';
import 'downloads_presenter.dart';
import 'downloads_state_machine.dart';

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

  void fetchStateList() {
    _presenter.fetchStateList(
      new UseCaseObserver(
        () {
          print('State list successfully fetched');
        },
        (error) {
          _handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List stateListRes) {
          stateList = stateListRes;
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
        selectedParams);
  }

  void downloadFilesMobile() {
    isDownloading = true;
    refreshUI();
    _presenter.getRequiredDownloadMobile(
        new UseCaseObserver(() {
          isDownloading = false;
          refreshUI();
          Fluttertoast.showToast(
            msg:
                'The file is downloaded at location => Android/data/com.example.agri_guide_web_app/required_downloads.zip',
            toastLength: Toast.LENGTH_LONG,
          );
        }, (error) {
          _handleAPIErrors(error);
          print(error);
        }),
        selectedStates,
        selectedDistricts,
        List<String>.from([fromText.text, toText.text]),
        selectedParams);
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
