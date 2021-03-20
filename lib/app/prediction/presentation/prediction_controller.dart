import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/enums.dart';
import '../../../core/exceptions.dart';
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
  PageController pageController = PageController();
  int currentPageNumber = 0;
  List stateList = [];
  List districtList = [];
  List seasonsList = [];
  List cropsList = [];
  bool isStateFilterClicked = false;
  bool isDistrictFilterClicked = false;
  String selectedState = '';
  String selectedDistrict = '';
  String selectedSeason;
  String selectedCrop;
  bool stateListLoading = false;
  bool districtListLoading = false;
  bool stateListInitialized = false;
  bool seasonListLoading = false;
  bool cropListLoading = false;
  bool areCropsAvailable = true;
  bool isLoadingFirstTime = true;
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
                _stateMachine.onEvent(new PredictionPageLoggedOutEvent());
                refreshUI();
              },
            ),
          );
        }
      }),
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

  void navigateToLogin() {
    navigationService.navigateTo(NavigationService.loginPage,
        shouldReplace: true);
  }

  void proceedToPrediction(int page) {
    currentPageNumber = page;
    pageController.jumpToPage(page);
    if (!isPredicting) makePrediction();
    refreshUI();
  }

  void handleStateFilterClicked() {
    if (isDistrictFilterClicked) {
    } else {
      isStateFilterClicked = !isStateFilterClicked;
    }
    refreshUI();
  }

  void handleDistrictFilterClicked() {
    if (isStateFilterClicked) {
    } else {
      isDistrictFilterClicked = !isDistrictFilterClicked;
    }
    refreshUI();
  }

  void fetchStateList() {
    stateListLoading = true;
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
        () {
          print('District list successfully fetched');
        },
        (error) {
          _handleAPIErrors(error);
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
        () {
          print('Seasons list successfully fetched');
        },
        (error) {
          _handleAPIErrors(error);
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
          _handleAPIErrors(error);
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
    isPredicting = true;
    _presenter.makePredictions(
      new UseCaseObserver(() {
        print('Complete');
      }, (error) {
        _handleAPIErrors(error);
        print(error);
      }, onNextFunction: (PredictionDataEntity entity) {
        predictionDataEntity = entity;
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
        if (areCropsAvailable) {
          predictedYield = predictionDataEntity.predictedYield;
        }
        isPredicting = false;
        refreshUI();
      }),
      selectedState,
      selectedDistrict,
      selectedSeason,
      selectedCrop,
    );
  }

  void handleRadioChangeOfState(String value) {
    selectedState = value;
    refreshUI();
  }

  void handleRadioChangeOfDistrict(String value) {
    selectedDistrict = value;
    refreshUI();
  }

  void selectedStateChange() {
    selectedDistrict = '';
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

  void handleStartMonthDropDownChange(String value) {
    startMonth = value;
    if (months.indexOf(startMonth) == 11) {
      startMonth = months[10];
    }
    if (months.indexOf(endMonth) <= months.indexOf(startMonth)) {
      endMonth = months[months.indexOf(startMonth) + 1];
    }
    refreshUI();
  }

  void handleEndMonthDropDownChange(String value) {
    endMonth = value;
    if (months.indexOf(endMonth) == 0) {
      endMonth = months[1];
    }
    if (months.indexOf(endMonth) <= months.indexOf(startMonth)) {
      endMonth = months[months.indexOf(startMonth) + 1];
    }
    refreshUI();
  }

  void handleSeasonDropDownChange(String value) {
    selectedSeason = value;
    selectedCrop = null;
    if (selectedSeason != '') fetchCropsList();
    refreshUI();
  }

  void handleCropDropDownChange(String value) {
    selectedCrop = value;
    refreshUI();
  }

  bool onWillPopScopePage1() {
    if (selectedCrop != null) {
      selectedCrop = null;
    } else if (selectedSeason != null) {
      selectedSeason = null;
    } else if (selectedDistrict != '') {
      selectedDistrict = '';
    } else if (selectedState != '') {
      selectedState = '';
      selectedDistrict = '';
      districtList = [];
    }
    refreshUI();

    return false;
  }

  bool onWillPopScopePage2() {
    pageController.jumpToPage(0);
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
