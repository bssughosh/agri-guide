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
  Widget get desktopView => ControlledWidgetBuilder<RegisterPageController>(
        builder: (context, controller) {
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
        },
      );

  @override
  Widget get mobileView => ControlledWidgetBuilder<RegisterPageController>(
        builder: (context, controller) {
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
        },
      );
  @override
  Widget get tabletView => mobileView;

  @override
  Widget get watchView => throw UnimplementedError();
}
