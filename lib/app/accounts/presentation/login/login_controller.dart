import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/exceptions.dart';
import '../../../../core/observer.dart';
import '../../../../injection_container.dart';
import '../../../../router/router_delegate.dart';
import '../../../../router/ui_pages.dart';
import 'login_presenter.dart';
import 'login_state_machine.dart';

class LoginPageController extends Controller {
  final LoginPagePresenter _presenter;
  final LoginStateMachine _stateMachine = new LoginStateMachine();
  LoginPageController()
      : _presenter = serviceLocator<LoginPagePresenter>(),
        super();
  TextEditingController emailText = new TextEditingController();
  TextEditingController passwordText = new TextEditingController();

  @override
  void initListeners() {}

  @override
  dispose() {
    _presenter.dispose();
    super.dispose();
  }

  LoginState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void updateEmailField(String value) {
    refreshUI();
  }

  void updatePasswordField(String value) {
    refreshUI();
  }

  void loginUser() {
    _stateMachine.onEvent(new LoginLoadingEvent());
    refreshUI();
    _presenter.loginWithEmailAndPassword(
      new UseCaseObserver(
          () => _handleLoginSuccess(), (error) => _handleLoginError(error)),
      emailText.text.trim(),
      passwordText.text.trim(),
    );
  }

  _handleLoginSuccess() {
    final delegate = serviceLocator<AgriGuideRouterDelegate>();
    delegate.replace(homePageConfig);
  }

  _handleLoginError(Exception error) {
    _stateMachine.onEvent(new LoginInitializedEvent());
    refreshUI();
    if (error.runtimeType == LoginInvalidCredentialsException) {
      Fluttertoast.showToast(msg: 'Email or passwords do not match');
    } else if (error.runtimeType == LoginNetworkRequestFailedException) {
      Fluttertoast.showToast(
          msg: 'Please have a persistent internet connection to proceed');
    } else if (error.runtimeType == LoginTooManyRequestException) {
      Fluttertoast.showToast(msg: 'There are too many requests at the moment');
    } else {
      Fluttertoast.showToast(msg: 'Login failed');
    }
    refreshUI();
  }

  void navigateToRegistration() {
    final delegate = serviceLocator<AgriGuideRouterDelegate>();
    delegate.addPage(registerPageConfig);
  }

  void navigateToHomepage() {
    final delegate = serviceLocator<AgriGuideRouterDelegate>();
    delegate.replace(homePageConfig);
  }

  bool onWillPopScope() {
    navigateToHomepage();

    return false;
  }
}
