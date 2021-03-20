import 'package:agri_guide/app/accounts/domain/entities/user_entity.dart';
import 'package:agri_guide/core/handle_api_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/enums.dart';
import '../../../core/observer.dart';
import '../../../injection_container.dart';
import '../../navigation_service.dart';
import '../domain/entity/live_weather_entity.dart';
import 'dashboard_presenter.dart';
import 'dashboard_state_machine.dart';

class DashboardPageController extends Controller {
  final DashboardPagePresenter _presenter;
  final DashboardPageStateMachine _stateMachine =
      new DashboardPageStateMachine();
  final navigationService = serviceLocator<NavigationService>();
  DashboardPageController()
      : _presenter = serviceLocator<DashboardPagePresenter>(),
        super();

  List stateList = [];
  List districtList = [];

  LiveWeatherEntity liveWeatherEntity;

  String selectedState;
  String selectedDistrict;

  bool stateListLoading = false;
  bool districtListLoading = false;
  bool isFetchingLiveWeather = false;
  bool isFirstTimeLoading = true;
  bool isPlaceChanged = false;

  LoginStatus loginStatus = LoginStatus.LOGGED_OUT;
  UserEntity userEntity;

  TextEditingController pincode = TextEditingController();

  @override
  void initListeners() {}

  DashboardState getCurrentState() {
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
          _stateMachine.onEvent(
            new DashboardPageInitializedEvent(loginStatus: status),
          );
          refreshUI();
        }
        if (status == LoginStatus.LOGGED_IN) {
          _presenter.fetchUserDetails(
            new UseCaseObserver(
              () {},
              (error) {
                print(error);
              },
              onNextFunction: (UserEntity user) {
                userEntity = user;
                fetchStateList();
                _stateMachine.onEvent(
                    new DashboardPageInitializedEvent(loginStatus: status));
                refreshUI();
              },
            ),
          );
        }
      }),
    );
  }

  void fetchStateList() {
    stateListLoading = true;
    _presenter.fetchStateList(
      new UseCaseObserver(() {}, (error) {
        handleAPIErrors(error);
        print(error);
      }, onNextFunction: (List stateListRes) {
        stateList = stateListRes;
        stateListLoading = false;
        String newState = namePreporcessing(userEntity.state);
        for (var state in stateListRes) {
          if (state['name'] == newState) {
            selectedState = state['id'];
            break;
          }
        }
        fetchDistrictList();
        refreshUI();
      }),
    );
  }

  void fetchDistrictList() {
    districtListLoading = true;
    _presenter.fetchDistrictList(
      new UseCaseObserver(() {}, (error) {
        handleAPIErrors(error);
        print(error);
      }, onNextFunction: (List districtListRes) {
        districtList = districtListRes;
        districtListLoading = false;
        if (isFirstTimeLoading) {
          String newDist = namePreporcessing(userEntity.district);
          for (var dist in districtListRes) {
            if (dist['name'] == newDist) {
              selectedDistrict = dist['id'];
              break;
            }
          }

          fetchLiveWeather();
        }
        isFirstTimeLoading = false;
        refreshUI();
      }),
      selectedState,
    );
  }

  void navigateToLogin() {
    navigationService.navigateTo(NavigationService.loginPage,
        shouldReplace: true);
  }

  void fetchLiveWeather() {
    isFetchingLiveWeather = true;
    _presenter.fetchLocationDetails(
      new UseCaseObserver(
        () {
          _presenter.fetchLiveWeather(
            new UseCaseObserver(() {}, (error) {
              print(error);
            }, onNextFunction: (LiveWeatherEntity _liveWeatherEntity) {
              liveWeatherEntity = _liveWeatherEntity;
              isFetchingLiveWeather = false;
              refreshUI();
            }),
          );
        },
        (error) {
          print(error);
        },
      ),
    );
  }

  void fetchLiveWeatherForNewLocation() {
    isFetchingLiveWeather = true;
    _presenter.fetchLocationDetailsForNewLocation(
      new UseCaseObserver(
        () {
          _presenter.fetchLiveWeatherForNewLocation(
            new UseCaseObserver(() {}, (error) {
              print(error);
            }, onNextFunction: (LiveWeatherEntity _liveWeatherEntity) {
              liveWeatherEntity = _liveWeatherEntity;
              isFetchingLiveWeather = false;
              refreshUI();
            }),
            district: selectedDistrictName(),
            state: selectedStateName(),
            pincode: pincode.text,
          );
        },
        (error) {
          print(error);
        },
      ),
      district: selectedDistrictName(),
      state: selectedStateName(),
      pincode: pincode.text,
    );
  }

  void selectedStateChange() {
    selectedDistrict = null;
    districtList = [];
    isFirstTimeLoading = true;
    refreshUI();
    fetchDistrictList();
  }

  void selectedDistrictChange() {
    isFirstTimeLoading = true;
    pincode.text = '';
    refreshUI();
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

  void textFieldChanged() {
    refreshUI();
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

  String namePreporcessing(String unprocessedString) {
    String str1 = unprocessedString.replaceAll(new RegExp(r'\+'), ' ');
    String str2 = str1.split(" ").map((str) => capitalize(str)).join(" ");
    return str2;
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
