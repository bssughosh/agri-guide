import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/app_theme.dart';
import '../../../core/enums.dart';
import 'dashboard_controller.dart';
import 'dashboard_state_machine.dart';
import 'widgets/live_weather_card.dart';
import 'widgets/location_card.dart';

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
        return _buildDashboardInitializationView();

      case DashboardPageInitializedState:
        DashboardPageInitializedState initializedState = currentState;
        return _buildDashboardInitializedViewMobile(
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
        return _buildDashboardInitializationView();

      case DashboardPageInitializedState:
        DashboardPageInitializedState initializedState = currentState;
        return _buildDashboardInitializedViewWeb(
          loginStatus: initializedState.loginStatus,
        );
    }
    throw Exception("Unknown state $currentState encountered");
  }

  Widget _buildDashboardInitializationView() {
    controller.checkForLoginStatus();
    return CircularProgressIndicator();
  }

  Widget _buildDashboardInitializedViewMobile(
      {@required LoginStatus loginStatus}) {
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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (controller.liveWeatherEntity == null ||
                controller.isFetchingLiveWeather)
              CircularProgressIndicator(),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              LocationCard(
                district: controller.liveWeatherEntity.location.district,
                state: controller.liveWeatherEntity.location.state,
              ),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              SizedBox(height: 30),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              LiveWeatherCard(
                icon: Icons.thermostat_rounded,
                title: 'Temperature',
                value: controller.liveWeatherEntity.temp + ' \u2103',
              ),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              LiveWeatherCard(
                icon: Icons.opacity,
                title: 'Humidity',
                value: controller.liveWeatherEntity.humidity + ' %',
              ),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              LiveWeatherCard(
                icon: Icons.wb_cloudy,
                title: 'Rainfall',
                value: controller.liveWeatherEntity.rain + ' mm',
              ),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              SizedBox(height: 30),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              Center(
                child: InkWell(
                  onTap: () {
                    controller.fetchLiveWeather();
                  },
                  child: Icon(
                    Icons.cached,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardInitializedViewWeb(
      {@required LoginStatus loginStatus}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (controller.liveWeatherEntity == null ||
                controller.isFetchingLiveWeather)
              CircularProgressIndicator(),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              LocationCard(
                district: controller.liveWeatherEntity.location.district,
                state: controller.liveWeatherEntity.location.state,
              ),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              SizedBox(height: 30),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              LiveWeatherCard(
                icon: Icons.thermostat_rounded,
                title: 'Temperature',
                value: controller.liveWeatherEntity.temp + ' \u2103',
              ),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              LiveWeatherCard(
                icon: Icons.opacity,
                title: 'Humidity',
                value: controller.liveWeatherEntity.humidity + ' %',
              ),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              LiveWeatherCard(
                icon: Icons.wb_cloudy,
                title: 'Rainfall',
                value: controller.liveWeatherEntity.rain + ' mm',
              ),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              SizedBox(height: 30),
            if (controller.liveWeatherEntity != null &&
                !controller.isFetchingLiveWeather)
              Center(
                child: InkWell(
                  onTap: () {
                    controller.fetchLiveWeather();
                  },
                  child: Icon(
                    Icons.cached,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
