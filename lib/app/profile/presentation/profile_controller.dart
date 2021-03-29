import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/enums.dart';
import '../../../core/handle_api_errors.dart';
import '../../../core/observer.dart';
import '../../../injection_container.dart' as di;
import '../../../injection_container.dart';
import '../../accounts/domain/entities/user_entity.dart';
import '../../navigation_service.dart';
import 'profile_presenter.dart';
import 'profile_state_machine.dart';

class ProfilePageController extends Controller {
  final ProfilePagePresenter _presenter;
  final ProfilePageStateMachine _stateMachine = new ProfilePageStateMachine();
  final navigationService = serviceLocator<NavigationService>();
  ProfilePageController()
      : _presenter = serviceLocator<ProfilePagePresenter>(),
        super();

  List stateList;
  List districtList;

  UserEntity userEntity;
  LoginStatus loginStatus = LoginStatus.LOGGED_OUT;
  TextEditingController name = new TextEditingController();
  TextEditingController area = new TextEditingController();
  TextEditingController pincode = new TextEditingController();
  TextEditingController aadhar = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController pass1 = new TextEditingController();
  TextEditingController pass2 = new TextEditingController();

  String selectedState;
  String selectedDistrict;

  bool isFirstTimeLoading = true;
  bool isProfileUpdated = false;

  @override
  void initListeners() {}

  ProfileState getCurrentState() {
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
            new ProfilePageLoggedOutEvent(),
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
                name.text = userEntity.name;
                aadhar.text = userEntity.aadhar;
                email.text = userEntity.email;
                pincode.text = userEntity.pincode;
                area.text = userEntity.area;
                _stateMachine.onEvent(new ProfilePageLoggedInEvent());
                refreshUI();
                fetchStateList();
              },
            ),
          );
        }
      }),
    );
  }

  void fetchStateList() {
    _stateMachine.onEvent(new ProfilePageLoadingEvent());
    refreshUI();
    _presenter.fetchStateList(
      new UseCaseObserver(() {}, (error) {
        handleAPIErrors(error);
        print(error);
      }, onNextFunction: (List stateListRes) {
        stateList = stateListRes;
        String newState = namePreporcessing(userEntity.state);
        for (var state in stateListRes) {
          if (state['name'] == newState) {
            selectedState = state['id'];
            break;
          }
        }
        _stateMachine.onEvent(new ProfilePageLoggedInEvent());
        refreshUI();

        fetchDistrictList();
      }),
    );
  }

  void fetchDistrictList() {
    _stateMachine.onEvent(new ProfilePageLoadingEvent());
    refreshUI();
    _presenter.fetchDistrictList(
      new UseCaseObserver(() {}, (error) {
        handleAPIErrors(error);
        print(error);
      }, onNextFunction: (List districtListRes) {
        districtList = districtListRes;
        if (isFirstTimeLoading) {
          String newDist = namePreporcessing(userEntity.district);
          for (var dist in districtListRes) {
            if (dist['name'] == newDist) {
              selectedDistrict = dist['id'];
              break;
            }
          }
          isFirstTimeLoading = false;
        }

        _stateMachine.onEvent(new ProfilePageLoggedInEvent());
        refreshUI();
      }),
      selectedState,
    );
  }

  void changePassword() {
    if (pass1.text.length > 0) {
      if (pass1.text != pass2.text) {
        Fluttertoast.showToast(msg: 'The passwords do not match');
      } else {
        _presenter.changePassword(
          new UseCaseObserver(() {
            Fluttertoast.showToast(msg: 'The password is updated');
          }, (error) {
            print(error);
          }),
          pass1.text,
        );
      }
    }
  }

  void updateUserDetails() {
    UserEntity _newEntity = UserEntity(
      name: name.text,
      email: email.text,
      aadhar: aadhar.text,
      state: selectedStateName(),
      district: selectedDistrictName(),
      area: area.text,
      pincode: pincode.text,
    );
    _presenter.updateUserDetails(
      new UseCaseObserver(() async {
        await di.reset();
        userEntity = null;
        isProfileUpdated = false;
        _stateMachine.onEvent(new ProfilePageInitializationEvent());
        refreshUI();
      }, (error) {
        print(error);
      }),
      _newEntity,
    );
  }

  void selectedStateChange() {
    isProfileUpdated = true;
    selectedDistrict = null;
    districtList = [];
    refreshUI();
    fetchDistrictList();
  }

  void selectedDistrictChange() {
    isProfileUpdated = true;
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
    isProfileUpdated = true;
    refreshUI();
  }

  void navigateToLogin() {
    navigationService.navigateTo(NavigationService.loginPage,
        shouldReplace: true);
  }

  void navigateToRegistration() {
    navigationService.navigateTo(NavigationService.registerPage,
        shouldReplace: true);
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
