import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'mobile/init_view.dart';
import 'splash_controller.dart';
import 'splash_state_machine.dart';
import 'web/init_view.dart';

class SplashPage extends View {
  @override
  State<StatefulWidget> createState() => SplashViewState();
}

class SplashViewState
    extends ResponsiveViewState<SplashPage, SplashPageController> {
  SplashViewState() : super(new SplashPageController());

  @override
  Widget get desktopView => ControlledWidgetBuilder<SplashPageController>(
        builder: (context, controller) {
          final currentStateType = controller.getCurrentState().runtimeType;

          switch (currentStateType) {
            case SplashInitState:
              return buildSplashInitViewWeb(
                controller: controller,
                context: context,
              );
          }
          throw Exception("Unrecognized state $currentStateType encountered");
        },
      );

  @override
  Widget get mobileView => ControlledWidgetBuilder<SplashPageController>(
        builder: (context, controller) {
          final currentStateType = controller.getCurrentState().runtimeType;

          switch (currentStateType) {
            case SplashInitState:
              return buildSplashInitViewMobile(controller: controller);
          }
          throw Exception("Unrecognized state $currentStateType encountered");
        },
      );

  @override
  Widget get tabletView => mobileView;

  @override
  Widget get watchView => throw UnimplementedError();
}
