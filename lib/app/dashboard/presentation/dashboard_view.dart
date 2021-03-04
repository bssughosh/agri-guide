import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/app_theme.dart';
import '../../../core/enums.dart';
import 'dashboard_controller.dart';
import 'dashboard_state_machine.dart';

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
    controller.checkForLoginStatus();
    return CircularProgressIndicator();
  }

  Widget _buildMobileDashboard({@required LoginStatus loginStatus}) {
    if (loginStatus == LoginStatus.LOGGED_OUT) {
      return Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'Please Login to get most out of the app',
                  style: AppTheme.headingBoldText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                TextButton(
                  child: Text(
                    'Login / Register',
                    style: AppTheme.navigationTabSelectedTextStyle,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppTheme.navigationSelectedColor),
                  ),
                  onPressed: () {
                    controller.navigateToLogin();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    return _mobileContentBody();
  }

  Widget _mobileContentBody() {
    controller.fetchLiveWeather();
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }

  Widget _buildWebDashboard({@required LoginStatus loginStatus}) {
    return Container();
  }
}
