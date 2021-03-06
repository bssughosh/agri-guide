import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/observer.dart';
import '../domain/usecase/fetch_live_weather_usecase.dart';
import '../domain/usecase/fetch_location_details_usecase.dart';

class DashboardPagePresenter extends Presenter {
  FetchLiveWeatherUsecase _fetchLiveWeatherUsecase;
  FetchLocationDetailsUsecase _fetchLocationDetailsUsecase;

  DashboardPagePresenter(
    this._fetchLiveWeatherUsecase,
    this._fetchLocationDetailsUsecase,
  );

  @override
  dispose() {
    _fetchLocationDetailsUsecase.dispose();
    _fetchLiveWeatherUsecase.dispose();
  }

  void fetchLocationDetails(UseCaseObserver observer) {
    _fetchLocationDetailsUsecase.execute(observer);
  }

  void fetchLiveWeather(UseCaseObserver observer) {
    _fetchLiveWeatherUsecase.execute(observer);
  }
}
