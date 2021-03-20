import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  bool stateListLoading = false;
  bool districtListLoading = false;
  bool stateListInitialized = false;
  bool seasonListLoading = false;
  bool cropListLoading = false;
  bool areCropsAvailable = true;
  bool isLoadingFirstTime = true;

  String startMonth;
  String endMonth;

  PredictionDataEntity predictionDataEntity;
  bool isPredicting = false;
  List<String> temperature = [];
  List<String> rainfall = [];
  List<String> humidity = [];
  double predictedYield = -1;
  List<String> monthsToDisplay = [];

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
                _stateMachine
                    .onEvent(new PredictionPageInputInitializedEvent());
                refreshUI();
              },
            ),
          );
        }
      }),
    );
  }

  void navigateToLogin() {
    navigationService.navigateTo(NavigationService.loginPage,
        shouldReplace: true);
  }

  void proceedToPrediction() {
    _stateMachine.onEvent(new PredictionPageLoadingEvent());
    refreshUI();
    if (!isPredicting) makePrediction();
    refreshUI();
  }

  void fetchStateList() {
    stateListLoading = true;
    _presenter.fetchStateList(
      new UseCaseObserver(
        () {},
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List stateListRes) {
          stateList = stateListRes;
          stateListLoading = false;
          stateListInitialized = true;
          String newState = namePreporcessing(userEntity.state);
          for (var state in stateListRes) {
            if (state['name'] == newState) {
              selectedState = state['id'];
              break;
            }
          }
          if (isLoadingFirstTime) fetchDistrictList();
          refreshUI();
        },
      ),
    );
  }

  void fetchDistrictList() {
    districtListLoading = true;
    _presenter.fetchDistrictList(
      new UseCaseObserver(
        () {},
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List districtListRes) {
          districtList = districtListRes;
          districtListLoading = false;
          String newDist = namePreporcessing(userEntity.district);
          for (var dist in districtListRes) {
            if (dist['name'] == newDist) {
              selectedDistrict = dist['id'];
              break;
            }
          }
          if (isLoadingFirstTime) {
            isLoadingFirstTime = false;
            fetchSeasonList();
          }
          refreshUI();
        },
      ),
      selectedState,
    );
  }

  void fetchSeasonList() {
    seasonListLoading = true;
    _presenter.fetchSeasonsList(
      new UseCaseObserver(
        () {},
        (error) {
          handleAPIErrors(error);
          print(error);
        },
        onNextFunction: (List seasonsRes) {
          seasonListLoading = false;
          if (seasonsRes.length > 0) {
            seasonsList = seasonsRes;
          } else {
            areCropsAvailable = false;
            selectedSeason = '';
            Fluttertoast.showToast(
              msg:
                  'There are no crops inout repository at the moment for your selected location',
            );
          }
          refreshUI();
        },
      ),
      selectedState,
      selectedDistrict,
    );
  }

  void fetchCropsList() {
    cropListLoading = true;
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
          cropListLoading = false;
          cropsList = cropsRes;
          refreshUI();
        },
      ),
      selectedState,
      selectedDistrict,
      selectedSeason,
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
        if (!areCropsAvailable) {
          int _startIndex = months.indexOf(startMonth);
          int _endIndex = months.indexOf(endMonth);
          temperature = List<String>.from(
            predictionDataEntity.temperature.getRange(
              _startIndex,
              _endIndex + 1,
            ),
          );
          humidity = List<String>.from(
            predictionDataEntity.humidity.getRange(
              _startIndex,
              _endIndex + 1,
            ),
          );
          rainfall = List<String>.from(
            predictionDataEntity.rainfall.getRange(
              _startIndex,
              _endIndex + 1,
            ),
          );
          monthsToDisplay = List<String>.from(
            months.getRange(
              _startIndex,
              _endIndex + 1,
            ),
          );
        } else {
          temperature = List<String>.from(selectedSeason == 'Kharif'
              ? [
                  predictionDataEntity.temperature[5],
                  predictionDataEntity.temperature[6],
                  predictionDataEntity.temperature[7],
                  predictionDataEntity.temperature[8],
                ]
              : [
                  predictionDataEntity.temperature[9],
                  predictionDataEntity.temperature[10],
                  predictionDataEntity.temperature[11],
                  predictionDataEntity.temperature[0],
                  predictionDataEntity.temperature[1],
                  predictionDataEntity.temperature[2],
                ]);
          humidity = List<String>.from(selectedSeason == 'Kharif'
              ? [
                  predictionDataEntity.humidity[5],
                  predictionDataEntity.humidity[6],
                  predictionDataEntity.humidity[7],
                  predictionDataEntity.humidity[8],
                ]
              : [
                  predictionDataEntity.humidity[9],
                  predictionDataEntity.humidity[10],
                  predictionDataEntity.humidity[11],
                  predictionDataEntity.humidity[0],
                  predictionDataEntity.humidity[1],
                  predictionDataEntity.humidity[2],
                ]);
          rainfall = List<String>.from(selectedSeason == 'Kharif'
              ? [
                  predictionDataEntity.rainfall[5],
                  predictionDataEntity.rainfall[6],
                  predictionDataEntity.rainfall[7],
                  predictionDataEntity.rainfall[8],
                ]
              : [
                  predictionDataEntity.rainfall[9],
                  predictionDataEntity.rainfall[10],
                  predictionDataEntity.rainfall[11],
                  predictionDataEntity.rainfall[0],
                  predictionDataEntity.rainfall[1],
                  predictionDataEntity.rainfall[2],
                ]);
          monthsToDisplay = List<String>.from(selectedSeason == 'Kharif'
              ? [
                  months[5],
                  months[6],
                  months[7],
                  months[8],
                ]
              : [
                  months[9],
                  months[10],
                  months[11],
                  months[0],
                  months[1],
                  months[2],
                ]);
        }
        if (areCropsAvailable) {
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

  void selectedStateChange() {
    selectedDistrict = null;
    districtList = [];
    seasonsList = [];
    cropsList = [];
    refreshUI();
    fetchDistrictList();
  }

  void selectedDistrictChange() {
    selectedCrop = null;
    selectedSeason = null;
    areCropsAvailable = true;
    seasonsList = [];
    cropsList = [];
    refreshUI();
    fetchSeasonList();
  }

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

  void selectedSeasonChange() {
    selectedCrop = null;
    areCropsAvailable = true;
    cropsList = [];

    refreshUI();
    fetchCropsList();
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

  void selectedCropChange() {
    refreshUI();
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

  String getCropNameFromCropId(String cropId) {
    for (var crop in cropsList) {
      if (cropId == crop['crop_id']) {
        return crop['name'];
      }
    }
    return '';
  }

  String calculatePersonalisedYield() {
    int area = int.parse(userEntity.area);
    double newYield = predictedYield * area / 10;
    return newYield.toStringAsFixed(3);
  }

  String namePreporcessing(String unprocessedString) {
    String str1 = unprocessedString.replaceAll(new RegExp(r'\+'), ' ');
    String str2 = str1.split(" ").map((str) => capitalize(str)).join(" ");
    return str2;
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
