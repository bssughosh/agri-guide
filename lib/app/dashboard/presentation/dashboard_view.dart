import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'dashboard_controller.dart';
import 'dashboard_state_machine.dart';
import 'mobile/initialization_view.dart';
import 'mobile/initialized_view.dart';
import 'web/initialized_view.dart';

class DashboardPage extends View {
  @override
  State<StatefulWidget> createState() => DashboardViewState();
}

class DashboardViewState
    extends ResponsiveViewState<DashboardPage, DashboardPageController> {
  DashboardViewState() : super(new DashboardPageController());

  @override
  Widget buildMobileView() {
    final currentState = controller.getCurrentState();
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case DashboardPageInitializationState:
        return buildDashboardInitializationView(
          controller: controller,
        );

      case DashboardPageInitializedState:
        DashboardPageInitializedState initializedState = currentState;
        return buildDashboardInitializedViewMobile(
          loginStatus: initializedState.loginStatus,
          context: context,
          controller: controller,
        );
    }
    throw Exception("Unknown state $currentState encountered");
  }

  @override
  Widget buildTabletView() {
    return buildMobileView();
  }

  @override
  Widget buildDesktopView() {
    final currentState = controller.getCurrentState();
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case DashboardPageInitializationState:
        return buildDashboardInitializationView(
          controller: controller,
        );

      case DashboardPageInitializedState:
        DashboardPageInitializedState initializedState = currentState;
        return buildDashboardInitializedViewWeb(
          loginStatus: initializedState.loginStatus,
          context: context,
          controller: controller,
        );
    }
    throw Exception("Unknown state $currentState encountered");
  }
}
