import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'login_controller.dart';
import 'login_state_machine.dart';
import 'mobile/initialization_view.dart';
import 'mobile/initialized_view.dart';
import 'mobile/loading_view.dart';
import 'web/initialized_view.dart';

class LoginPage extends View {
  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState
    extends ResponsiveViewState<LoginPage, LoginPageController> {
  LoginViewState() : super(new LoginPageController());

  @override
  Widget get desktopView => ControlledWidgetBuilder<LoginPageController>(
        builder: (context, controller) {
          final currentStateType = controller.getCurrentState().runtimeType;

          switch (currentStateType) {
            case LoginInitializationState:
              return buildLoginInitilizationView();

            case LoginInitializedState:
              return buildLoginInitializedViewWeb(
                  controller: controller, context: context);

            case LoginLoadingState:
              return buildLoginLoadingView();
          }
          throw Exception("Unrecognized state $currentStateType encountered");
        },
      );

  @override
  Widget get mobileView => ControlledWidgetBuilder<LoginPageController>(
        builder: (context, controller) {
          final currentStateType = controller.getCurrentState().runtimeType;

          switch (currentStateType) {
            case LoginInitializationState:
              return buildLoginInitilizationView();

            case LoginInitializedState:
              return buildLoginInitializedViewMobile(
                  controller: controller, context: context);

            case LoginLoadingState:
              return buildLoginLoadingView();
          }
          throw Exception("Unrecognized state $currentStateType encountered");
        },
      );

  @override
  Widget get tabletView => mobileView;

  @override
  Widget get watchView => throw UnimplementedError();
}
