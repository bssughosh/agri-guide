import 'package:agri_guide/app/dashboard/presentation/dashboard_state_machine.dart';
import 'package:agri_guide/core/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'dashboard_controller.dart';

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
        return _buildLoadingScreen();

      case DashboardPageInitializedState:
        DashboardPageInitializedState initializedState = currentState;
        return _buildMobileDashboard(
          loginStatus: initializedState.loginStatus,
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
        return _buildLoadingScreen();

      case DashboardPageInitializedState:
        DashboardPageInitializedState initializedState = currentState;
        return _buildWebDashboard(
          loginStatus: initializedState.loginStatus,
        );
    }
    throw Exception("Unknown state $currentState encountered");
  }

  Widget _buildLoadingScreen() {
    return CircularProgressIndicator();
  }

  Widget _buildMobileDashboard({@required LoginStatus loginStatus}) {
    return Container();
  }

  Widget _buildWebDashboard({@required LoginStatus loginStatus}) {
    return Container();
  }
}
