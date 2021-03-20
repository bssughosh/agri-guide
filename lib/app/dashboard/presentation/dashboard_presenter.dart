import 'package:agri_guide/app/dashboard/domain/usecase/fetch_live_weather_for_new_location_usecase.dart';
import 'package:agri_guide/app/dashboard/domain/usecase/fetch_location_details_for_new_location_usecase.dart';
import 'package:agri_guide/app/downloads/domain/usecase/fetch_district_list_usecase.dart';
import 'package:agri_guide/app/downloads/domain/usecase/fetch_state_list_usecase.dart';
import 'package:agri_guide/app/prediction/domain/usecase/fetch_user_details_usecase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/observer.dart';
import '../../accounts/domain/usecase/check_login_status_usecase.dart';
import '../domain/usecase/fetch_live_weather_usecase.dart';
import '../domain/usecase/fetch_location_details_usecase.dart';

class DashboardPagePresenter extends Presenter {
  FetchLiveWeatherUsecase _fetchLiveWeatherUsecase;
  FetchLocationDetailsUsecase _fetchLocationDetailsUsecase;
  FetchLiveWeatherForNewLocationUsecase _fetchLiveWeatherForNewLocationUsecase;
  FetchLocationDetailsForNewLocationUsecase
      _fetchLocationDetailsForNewLocationUsecase;
  CheckLoginStatusUsecase _checkLoginStatusUsecase;
  FetchStateListUsecase _fetchStateListUsecase;
  FetchDistrictListUsecase _fetchDistrictListUsecase;
  FetchUserDetailsUsecase _fetchUserDetailsUsecase;

  DashboardPagePresenter(
    this._fetchLiveWeatherUsecase,
    this._fetchLocationDetailsUsecase,
    this._checkLoginStatusUsecase,
    this._fetchLiveWeatherForNewLocationUsecase,
    this._fetchLocationDetailsForNewLocationUsecase,
    this._fetchStateListUsecase,
    this._fetchDistrictListUsecase,
    this._fetchUserDetailsUsecase,
  );

  @override
  dispose() {
    _fetchLocationDetailsUsecase.dispose();
    _fetchLiveWeatherUsecase.dispose();
    _checkLoginStatusUsecase.dispose();
    _fetchLocationDetailsForNewLocationUsecase.dispose();
    _fetchLiveWeatherForNewLocationUsecase.dispose();
    _fetchStateListUsecase.dispose();
    _fetchDistrictListUsecase.dispose();
    _fetchUserDetailsUsecase.dispose();
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

  void fetchLocationDetailsForNewLocation(
    UseCaseObserver observer, {
    @required String state,
    @required String district,
    @required String pincode,
  }) {
    _fetchLocationDetailsForNewLocationUsecase.execute(
      observer,
      new FetchLocationDetailsForNewLocationParams(
          state: state, district: district, pincode: pincode),
    );
  }

  void fetchLiveWeatherForNewLocation(
    UseCaseObserver observer, {
    @required String state,
    @required String district,
    @required String pincode,
  }) {
    _fetchLiveWeatherForNewLocationUsecase.execute(
      observer,
      new FetchLiveWeatherForNewLocationParams(
          state: state, district: district, pincode: pincode),
    );
  }

  void fetchStateList(UseCaseObserver observer) {
    _fetchStateListUsecase.execute(observer);
  }

  void fetchDistrictList(UseCaseObserver observer, String stateId) {
    _fetchDistrictListUsecase.execute(
      observer,
      new DistrictListParams(
        stateId,
      ),
    );
  }

  void fetchUserDetails(UseCaseObserver observer) {
    _fetchUserDetailsUsecase.execute(observer);
  }
}
