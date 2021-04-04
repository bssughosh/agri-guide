import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/enums.dart';
import '../../../core/handle_api_errors.dart';
import '../../../core/observer.dart';
import '../../../injection_container.dart';
import '../../accounts/domain/entities/user_entity.dart';
import '../../navigation_service.dart';
import '../domain/entities/prediction_data_entity.dart';
import 'prediction_presenter.dart';
import 'prediction_state_machine.dart';

class PredictionPageController extends Controller {
  final PredictionPagePresenter _presenter;
  final PredictionPageStateMachine _stateMachine =
      new PredictionPageStateMachine();
  final navigationService = serviceLocator<NavigationService>();
  PredictionPageController()
      : _presenter = serviceLocator<PredictionPagePresenter>(),
        super();

  LoginStatus loginStatus = LoginStatus.LOGGED_OUT;
  UserEntity userEntity;

  List stateList = [];
  List districtList = [];
  List seasonsList = [];
  List cropsList = [];
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String selectedState;
  String selectedDistrict;
  String selectedSeason;
  String selectedCrop;

  bool stateListInitialized = false;
  bool areCropsAvailable = false;
  bool isLoadingFirstTime = true;

  List paramsList = [
    {'id': describeEnum(DownloadParams.temp), 'name': 'Temperature'},
    {'id': describeEnum(DownloadParams.humidity), 'name': 'Humidity'},
    {'id': describeEnum(DownloadParams.rainfall), 'name': 'Rainfall'},
  ];

  List<String> selectedParams = [];

  String startMonth;
  String endMonth;

  PredictionDataEntity predictionDataEntity;
  bool isPredicting = false;
  List<String> temperature = [];
  List<String> rainfall = [];
  List<String> humidity = [];
  double predictedYield = -1;
  List<String> monthsToDisplay = [];

  TextEditingController areaText = TextEditingController();

  Map<String, List<int>> _monthsForSeasons = {
    'Kharif': [5, 6, 7, 8, 9],
    'Rabi': [10, 11, 0, 1, 2, 3],
    'Whole Year': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
    'Autumn': [8, 9],
    'Summer': [2, 3, 4],
    'Winter': [11, 0, 1],
  };

  @override
  void initListeners() {}

  PredictionState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  @override
  dispose() {
    _presenter.dispose();
    super.dispose();
  }

  // API Calls

  void checkForLoginStatus() {
    _presenter.checkLoginStatus(
      new UseCaseObserver(() {}, (error) {
        print(error);
        handleAPIErrors(error);
      }, onNextFunction: (LoginStatus status) {
        loginStatus = status;
        if (status == LoginStatus.LOGGED_OUT) {
          _stateMachine.onEvent(new PredictionPageLoggedOutEvent());
          refreshUI();
        } else {
          _presenter.fetchUserDetails(
            new UseCaseObserver(
              () {},
              (error) {
                print(error);
              },
              onNextFunction: (UserEntity user) {
                userEntity = user;
                fetchStateList();
              },
            ),
          );
        }
      }),
    );
  }

  void fetchStateList() {
    _presenter.fetchStateList(
      new UseCaseObserver(
        () {},
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List stateListRes) {
          stateList = stateListRes;
          stateListInitialized = true;
          String newState = namePreporcessing(userEntity.state);
          for (var state in stateListRes) {
            if (state['name'] == newState) {
              selectedState = state['id'];
              break;
            }
          }
          _stateMachine.onEvent(new PredictionPageInputInitializedEvent());
          refreshUI();
          if (isLoadingFirstTime) fetchDistrictList();
        },
      ),
    );
  }

  void fetchDistrictList() {
    _stateMachine.onEvent(new PredictionPageLoadingEvent());
    refreshUI();
    _presenter.fetchDistrictList(
      new UseCaseObserver(
        () {},
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List districtListRes) {
          districtList = districtListRes;

          String newDist = namePreporcessing(userEntity.district);
          for (var dist in districtListRes) {
            if (dist['name'] == newDist) {
              selectedDistrict = dist['id'];
              break;
            }
          }
          _stateMachine.onEvent(new PredictionPageInputInitializedEvent());
          refreshUI();
          if (isLoadingFirstTime) {
            isLoadingFirstTime = false;
            fetchCropsList();
          }
        },
      ),
      selectedState,
    );
  }

  void fetchCropsList() {
    _stateMachine.onEvent(new PredictionPageLoadingEvent());
    refreshUI();
    _presenter.fetchCropList(
      new UseCaseObserver(
        () {
          print('Crops list successfully fetched');
        },
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List cropsRes) {
          cropsList = cropsRes;
          if (cropsRes.length > 0) {
            areCropsAvailable = true;
            selectedCrop = null;
            paramsList.add(
                {'id': describeEnum(DownloadParams.yield), 'name': 'Yield'});
          } else {
            areCropsAvailable = false;
            selectedCrop = null;
          }
          _stateMachine.onEvent(new PredictionPageInputInitializedEvent());
          refreshUI();
        },
      ),
      selectedState,
      selectedDistrict,
    );
  }

  void fetchSeasonList() {
    _stateMachine.onEvent(new PredictionPageLoadingEvent());
    refreshUI();
    _presenter.fetchSeasonsList(
      new UseCaseObserver(
        () {},
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List seasonsRes) {
          seasonsList = seasonsRes;

          _stateMachine.onEvent(new PredictionPageInputInitializedEvent());
          refreshUI();
        },
      ),
      selectedState,
      selectedDistrict,
      selectedCrop,
    );
  }

  void makePrediction() {
    _presenter.makePredictions(
      new UseCaseObserver(() {
        print('Complete');
      }, (error) {
        handleAPIErrors(error);
        print(error);
      }, onNextFunction: (PredictionDataEntity entity) {
        predictionDataEntity = entity;
        temperature = getListToBeDisplayed(predictionDataEntity.temperature);
        humidity = getListToBeDisplayed(predictionDataEntity.humidity);
        rainfall = getListToBeDisplayed(predictionDataEntity.rainfall);
        monthsToDisplay = getListToBeDisplayed(months);

        if (selectedSeason != null && selectedCrop != null) {
          predictedYield = predictionDataEntity.predictedYield;
        }

        _stateMachine.onEvent(new PredictionPageDisplayInitializedEvent());
        refreshUI();
      }),
      selectedState,
      selectedDistrict,
      selectedSeason,
      selectedCrop,
    );
  }

  // Dropdowns generators

  List<DropdownMenuItem> stateItems() {
    List<DropdownMenuItem> _list = [];
    for (var state in stateList) {
      _list.add(
        new DropdownMenuItem(
          value: state['id'],
          child: Text(state['name']),
        ),
      );
    }
    return _list;
  }

  List<DropdownMenuItem> districtItems() {
    List<DropdownMenuItem> _list = [];
    for (var district in districtList) {
      _list.add(
        new DropdownMenuItem(
          value: district['id'],
          child: Text(district['name']),
        ),
      );
    }
    return _list;
  }

  List<DropdownMenuItem> monthItems() {
    List<DropdownMenuItem> _list = [];
    for (var month in months) {
      _list.add(
        new DropdownMenuItem(
          value: month,
          child: Text(month),
        ),
      );
    }
    return _list;
  }

  List<DropdownMenuItem> seasonItems() {
    List<DropdownMenuItem> _list = [];
    for (var season in seasonsList) {
      _list.add(
        new DropdownMenuItem(
          value: season,
          child: Text(season),
        ),
      );
    }
    return _list;
  }

  List<DropdownMenuItem> cropItems() {
    List<DropdownMenuItem> _list = [];
    for (var crop in cropsList) {
      _list.add(
        new DropdownMenuItem(
          value: crop['crop_id'],
          child: Text(crop['name']),
        ),
      );
    }
    return _list;
  }

  // Dropdowns on select

  void selectedStateChange() {
    selectedDistrict = null;
    districtList = [];
    seasonsList = [];
    cropsList = [];
    selectedCrop = null;
    selectedSeason = null;
    areCropsAvailable = true;
    if (paramsList.length == 4) {
      paramsList.removeLast();
    }
    selectedParams = [];
    areaText.text = '';
    refreshUI();
    fetchDistrictList();
  }

  void selectedDistrictChange() {
    selectedCrop = null;
    selectedSeason = null;
    areCropsAvailable = true;
    seasonsList = [];
    cropsList = [];
    if (paramsList.length == 4) {
      paramsList.removeLast();
    }
    selectedParams = [];
    areaText.text = '';
    refreshUI();
    fetchCropsList();
  }

  void fromMonthUpdated(String newMonth) {
    startMonth = newMonth;
    if (startMonth == 'December') {
      startMonth = 'November';
    }
    if (endMonth != null && startMonth != null) {
      if (months.indexOf(startMonth) >= months.indexOf(endMonth)) {
        endMonth = months[months.indexOf(startMonth) + 1];
      }
    }

    refreshUI();
  }

  void toMonthUpdated(String newMonth) {
    endMonth = newMonth;
    if (endMonth == 'January') {
      endMonth = 'February';
    }
    if (endMonth != null && startMonth != null) {
      if (months.indexOf(startMonth) >= months.indexOf(endMonth)) {
        startMonth = months[months.indexOf(endMonth) - 1];
      }
    }

    refreshUI();
  }

  void selectedCropChange() {
    selectedSeason = null;
    seasonsList = [];
    refreshUI();
    fetchSeasonList();
  }

  void selectedSeasonChange() {
    refreshUI();
  }

  // Pamareters list update

  void updateParamsList(List<String> newParamsList) {
    selectedParams = newParamsList;
    if (!selectedParams.contains(describeEnum(DownloadParams.yield))) {
      selectedSeason = null;
      selectedCrop = null;
    }
    refreshUI();
  }

  // Navigations

  void navigateToLogin() {
    navigationService.navigateTo(NavigationService.loginPage,
        shouldReplace: true);
  }

  void navigateToRegistration() {
    navigationService.navigateTo(NavigationService.registerPage,
        shouldReplace: true);
  }

  void proceedToPrediction() {
    _stateMachine.onEvent(new PredictionPageLoadingEvent());
    refreshUI();
    if (!isPredicting) makePrediction();
    refreshUI();
  }

  // Utils

  List<String> getListToBeDisplayed(List<String> wholeList) {
    List<String> _res = [];

    List<int> _months = [];

    if (selectedParams.contains(describeEnum(DownloadParams.yield))) {
      _months = _monthsForSeasons[selectedSeason];
    } else {
      int _startIndex = months.indexOf(startMonth);
      int _endIndex = months.indexOf(endMonth);
      for (int i = _startIndex; i <= _endIndex; i++) {
        _months.add(i);
      }
    }

    for (int month in _months) {
      _res.add(wholeList[month]);
    }

    return _res;
  }

  void textFieldChanged() {
    refreshUI();
  }

  String getCropNameFromCropId(String cropId) {
    for (var crop in cropsList) {
      if (cropId == crop['crop_id']) {
        return crop['name'];
      }
    }
    return '';
  }

  String calculatePersonalisedYield() {
    int area = areaText.text.length == 0
        ? int.parse(userEntity.area)
        : int.parse(areaText.text);
    double newYield = predictedYield * area / 10;
    return newYield.toStringAsFixed(3);
  }

  String namePreporcessing(String unprocessedString) {
    String str1 = unprocessedString.replaceAll(new RegExp(r'\+'), ' ');
    String str2 = str1.split(" ").map((str) => capitalize(str)).join(" ");
    return str2;
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String getColumnNameForTable(TableType tableType) {
    if (tableType == TableType.TEMPERATURE) {
      return 'Predicted Temperature (\u2103)';
    } else if (tableType == TableType.HUMIDITY) {
      return 'Predicted Humidity (%)';
    } else if (tableType == TableType.RAINFALL) {
      return 'Predicted Rainfall (mm)';
    }
    throw Exception('Table type not recognized $tableType');
  }

  String selectedStateName() {
    String name = stateList
        .singleWhere((element) => element['id'] == selectedState)['name'];
    return name;
  }

  String selectedDistrictName() {
    String name = districtList
        .singleWhere((element) => element['id'] == selectedDistrict)['name'];
    return name;
  }

  bool onWillPopScopePage1() {
    if (selectedCrop != null) {
      selectedCrop = null;
    } else if (selectedSeason != null) {
      selectedSeason = null;
    } else if (selectedDistrict != null) {
      selectedDistrict = null;
    } else if (selectedState != null) {
      selectedState = null;
      selectedDistrict = null;
      districtList = [];
    }
    refreshUI();

    return false;
  }

  bool onWillPopScopePage2() {
    _stateMachine.onEvent(new PredictionPageInputInitializedEvent());
    refreshUI();

    return false;
  }
}
