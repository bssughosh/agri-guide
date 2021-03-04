import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/enums.dart';
import '../../../core/observer.dart';
import '../../../injection_container.dart';
import '../../navigation_service.dart';
import '../domain/entity/live_weather_entity.dart';
import 'dashboard_presenter.dart';
import 'dashboard_state_machine.dart';

class DashboardPageController extends Controller {
  final DashboardPagePresenter _presenter;
  final DashboardPageStateMachine _stateMachine =
      new DashboardPageStateMachine();
  final navigationService = serviceLocator<NavigationService>();
  DashboardPageController()
      : _presenter = serviceLocator<DashboardPagePresenter>(),
        super();

  LiveWeatherEntity liveWeatherEntity;

  @override
  void initListeners() {}

  DashboardState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  @override
  dispose() {
    _presenter.dispose();
    super.dispose();
  }

  void checkForLoginStatus() {
    _presenter.checkLoginStatus(
      new UseCaseObserver(() {}, (error) {
        print(error);
      }, onNextFunction: (LoginStatus status) {
        _stateMachine.onEvent(
          new DashboardPageInitializedEvent(loginStatus: status),
        );
        refreshUI();
      }),
    );
  }

  void navigateToLogin() {
    navigationService.navigateTo(NavigationService.loginPage,
        shouldReplace: true);
  }

  void fetchLiveWeather() {
    _presenter.fetchLocationDetails(
      new UseCaseObserver(
        () {
          _presenter.fetchLiveWeather(
            new UseCaseObserver(() {}, (error) {
              print(error);
            }, onNextFunction: (LiveWeatherEntity _liveWeatherEntity) {
              liveWeatherEntity = _liveWeatherEntity;
              print(liveWeatherEntity.temp);
              print(liveWeatherEntity.rain);
              print(liveWeatherEntity.humidity);
              refreshUI();
            }),
          );
        },
        (error) {
          print(error);
        },
      ),
    );
  }
}
