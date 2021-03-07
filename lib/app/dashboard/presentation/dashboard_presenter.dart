import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/observer.dart';
import '../../accounts/domain/usecase/check_login_status_usecase.dart';
import '../domain/usecase/fetch_live_weather_usecase.dart';
import '../domain/usecase/fetch_location_details_usecase.dart';

class DashboardPagePresenter extends Presenter {
  FetchLiveWeatherUsecase _fetchLiveWeatherUsecase;
  FetchLocationDetailsUsecase _fetchLocationDetailsUsecase;
  CheckLoginStatusUsecase _checkLoginStatusUsecase;

  DashboardPagePresenter(
    this._fetchLiveWeatherUsecase,
    this._fetchLocationDetailsUsecase,
    this._checkLoginStatusUsecase,
  );

  @override
  dispose() {
    _fetchLocationDetailsUsecase.dispose();
    _fetchLiveWeatherUsecase.dispose();
    _checkLoginStatusUsecase.dispose();
  }

  void checkLoginStatus(UseCaseObserver observer) {
    _checkLoginStatusUsecase.execute(observer);
  }

  void fetchLocationDetails(UseCaseObserver observer) {
    _fetchLocationDetailsUsecase.execute(observer);
  }

  void fetchLiveWeather(UseCaseObserver observer) {
    _fetchLiveWeatherUsecase.execute(observer);
  }
}
