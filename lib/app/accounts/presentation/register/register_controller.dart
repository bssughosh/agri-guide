import 'package:agri_guide/core/handle_api_errors.dart';
import 'package:checkdigit/checkdigit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/exceptions.dart';
import '../../../../core/observer.dart';
import '../../../../injection_container.dart';
import '../../../navigation_service.dart';
import '../../domain/entities/user_entity.dart';
import 'register_presenter.dart';
import 'register_state_machine.dart';

class RegisterPageController extends Controller {
  final RegisterPagePresenter _presenter;
  final RegisterStateMachine _stateMachine = new RegisterStateMachine();
  final navigationService = serviceLocator<NavigationService>();
  RegisterPageController()
      : _presenter = serviceLocator<RegisterPagePresenter>(),
        super();

  int currentPageNumber = 0;
  int lastPageNumber = 2;
  PageController pageController = PageController();
  List stateList;
  List districtList;

  //Page 1
  String selectedState;
  String selectedDistrict;
  TextEditingController areaText = new TextEditingController();
  TextEditingController pincodeText = new TextEditingController();
  bool stateListInitialized = false;

  //Page 2
  TextEditingController nameText = new TextEditingController();
  TextEditingController emailText = new TextEditingController();
  TextEditingController phoneText = new TextEditingController();
  TextEditingController aadharText = new TextEditingController();

  //Page 3
  TextEditingController pass1Text = new TextEditingController();
  TextEditingController pass2Text = new TextEditingController();
  bool doBothPassMatch = true;

  @override
  void initListeners() {}

  RegisterState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  @override
  dispose() {
    _presenter.dispose();
    super.dispose();
  }

  void fetchStateList() {
    _stateMachine.onEvent(new RegisterLoadingEvent());
    refreshUI();
    _presenter.fetchStateList(
      new UseCaseObserver(() {}, (error) {
        handleAPIErrors(error);
        print(error);
      }, onNextFunction: (List stateListRes) {
        stateList = stateListRes;

        stateListInitialized = true;

        _stateMachine.onEvent(new RegisterInitializedEvent());
        refreshUI();
      }),
    );
  }

  void fetchDistrictList() {
    _stateMachine.onEvent(new RegisterLoadingEvent());
    refreshUI();
    _presenter.fetchDistrictList(
      new UseCaseObserver(() {}, (error) {
        handleAPIErrors(error);
        print(error);
      }, onNextFunction: (List districtListRes) {
        districtList = districtListRes;
        _stateMachine.onEvent(new RegisterInitializedEvent());
        refreshUI();
      }),
      selectedState,
    );
  }

  void selectedStateChange() {
    selectedDistrict = null;
    districtList = [];
    refreshUI();
    fetchDistrictList();
  }

  void selectedDistrictChange() {
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

  void updatePageNumber(int page) {
    currentPageNumber = page;
    pageController.jumpToPage(page);
    refreshUI();
  }

  void backButtonPressed() {
    updatePageNumber(currentPageNumber - 1);
  }

  void textFieldChanged() {
    if (pass1Text.text.length != 0) {
      if (pass2Text.text.length != 0) {
        if (pass1Text.text != pass2Text.text) {
          doBothPassMatch = false;
        } else {
          doBothPassMatch = true;
        }
      } else {
        doBothPassMatch = true;
      }
    } else {
      doBothPassMatch = true;
    }
    refreshUI();
  }

  bool validatePage1() {
    if (pincodeText.text.length == 0) {
      Fluttertoast.showToast(msg: 'Pincode cannot be empty');
      return false;
    } else if (pincodeText.text.length != 6) {
      Fluttertoast.showToast(msg: 'Pincode entered appears to be wrong');
      return false;
    } else if (areaText.text.length == 0) {
      Fluttertoast.showToast(msg: 'Area cannot be empty');
      return false;
    }
    return true;
  }

  bool validatePage2() {
    if (nameText.text.length == 0) {
      Fluttertoast.showToast(msg: 'Name cannot be empty');
      return false;
    } else if (emailText.text.length == 0) {
      Fluttertoast.showToast(msg: 'Email ID cannot be empty');
      return false;
    } else if (aadharText.text.length == 0) {
      Fluttertoast.showToast(msg: 'Aadhar Card number cannot be empty');
      return false;
    } else if (!verhoeff.validate(aadharText.text.trim())) {
      Fluttertoast.showToast(msg: 'Please enter a valid Aadhar Card number');
      return false;
    } else if (!EmailValidator.validate(emailText.text.trim())) {
      Fluttertoast.showToast(msg: 'Please enter a valid Email ID');
      return false;
    } else if (phoneText.text != '') {
      if (phoneText.text.length != 10) {
        Fluttertoast.showToast(msg: 'Please enter a valid Mobile number');
        return false;
      }
    }
    return true;
  }

  bool validatePage3() {
    if (pass1Text.text.length == 0) {
      Fluttertoast.showToast(msg: 'Passwords cannot be empty');
      return false;
    } else if (pass2Text.text.length == 0) {
      Fluttertoast.showToast(msg: 'Passwords cannot be empty');
      return false;
    } else if (pass2Text.text != pass1Text.text) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
      return false;
    }
    return true;
  }

  void nextButtonPressed() {
    if (currentPageNumber == 0) {
      if (!validatePage1()) return;
    }
    if (currentPageNumber == 1) {
      if (!validatePage2()) return;
    }
    updatePageNumber(currentPageNumber + 1);
  }

  void submitButtonPressed() {
    if (!validatePage3()) return;
    UserEntity newUser = new UserEntity(
      aadhar: aadharText.text,
      state: selectedState,
      district: selectedDistrict,
      name: nameText.text,
      email: emailText.text,
      area: areaText.text,
      mobile: phoneText.text,
      pincode: pincodeText.text,
    );
    _stateMachine.onEvent(new RegisterLoadingEvent());
    refreshUI();
    _presenter.createNewUser(
      new UseCaseObserver(() => _handleRegisterSuccess(),
          (error) => _handleRegisterError(error)),
      newUser,
      pass1Text.text,
    );
  }

  _handleRegisterSuccess() {
    navigationService.navigateTo(NavigationService.homepage,
        shouldReplace: true);
  }

  _handleRegisterError(Exception error) {
    _stateMachine.onEvent(new RegisterInitializedEvent());
    refreshUI();
    if (error.runtimeType == RegisterWeakPasswordException) {
      Fluttertoast.showToast(msg: 'Please enter a strong password');
    } else if (error.runtimeType == RegisterEmailAlreadyInUseException) {
      Fluttertoast.showToast(msg: 'The email ID you entered is already in use');
    } else {
      Fluttertoast.showToast(msg: 'Registration failed');
    }
    refreshUI();
  }

  void navigateToHomepage() {
    navigationService.navigateTo(NavigationService.homepage,
        shouldReplace: true);
  }

  bool onWillPopScope() {
    navigateToHomepage();

    return false;
  }
}
