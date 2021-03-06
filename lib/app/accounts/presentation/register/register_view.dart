import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'mobile/initialized_view.dart';
import 'mobile/loading_view.dart';
import 'register_controller.dart';
import 'register_state_machine.dart';

class RegisterPage extends View {
  @override
  State<StatefulWidget> createState() => RegisterViewState();
}

class RegisterViewState
    extends ResponsiveViewState<RegisterPage, RegisterPageController> {
  RegisterViewState() : super(new RegisterPageController());

  @override
  void initState() {
    controller.emailText.text = '';
    controller.aadharText.text = '';
    controller.phoneText.text = '';
    controller.nameText.text = '';
    controller.areaText.text = '';
    controller.pass1Text.text = '';
    controller.pass2Text.text = '';
    super.initState();
  }

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case RegisterInitializedState:
        return buildRegistrationInitializedView(
          isWeb: false,
          controller: controller,
          context: context,
        );
      case RegisterLoadingState:
        return buildRegistrationLoadingView();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  @override
  Widget buildTabletView() {
    return buildMobileView();
  }

  @override
  Widget buildDesktopView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case RegisterInitializedState:
        return buildRegistrationInitializedView(
          isWeb: true,
          controller: controller,
          context: context,
        );
      case RegisterLoadingState:
        return buildRegistrationLoadingView();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }
}
