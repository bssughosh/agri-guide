import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/observer.dart';
import '../../accounts/domain/usecase/check_login_status_usecase.dart';
import '../../downloads/domain/usecase/fetch_crop_list_usecase.dart';
import '../../downloads/domain/usecase/fetch_district_list_usecase.dart';
import '../../downloads/domain/usecase/fetch_seasons_list_usecase.dart';
import '../../downloads/domain/usecase/fetch_state_list_usecase.dart';
import '../../profile/domain/usecase/fetch_user_details_usecase.dart';
import '../domain/usecase/make_prediction_usecase.dart';

class PredictionPagePresenter extends Presenter {
  FetchUserDetailsUsecase? _fetchUserDetailsUsecase;
  MakePredictionUsecase? _makePredictionUsecase;
  FetchStateListUsecase? _fetchStateListUsecase;
  FetchDistrictListUsecase? _fetchDistrictListUsecase;
  FetchSeasonsListUsecase? _fetchSeasonsListUsecase;
  FetchCropListUsecase? _fetchCropListUsecase;
  CheckLoginStatusUsecase? _checkLoginStatusUsecase;

  PredictionPagePresenter(
    this._fetchUserDetailsUsecase,
    this._makePredictionUsecase,
    this._fetchStateListUsecase,
    this._fetchDistrictListUsecase,
    this._fetchSeasonsListUsecase,
    this._fetchCropListUsecase,
    this._checkLoginStatusUsecase,
  );

  @override
  dispose() {
    _fetchUserDetailsUsecase!.dispose();
    _makePredictionUsecase!.dispose();
    _fetchStateListUsecase!.dispose();
    _fetchDistrictListUsecase!.dispose();
    _fetchSeasonsListUsecase!.dispose();
    _fetchCropListUsecase!.dispose();
    _checkLoginStatusUsecase!.dispose();
  }

  void checkLoginStatus(UseCaseObserver observer) {
    _checkLoginStatusUsecase!.execute(observer);
  }

  void fetchUserDetails(UseCaseObserver observer) {
    _fetchUserDetailsUsecase!.execute(observer);
  }

  void makePredictions(
    UseCaseObserver observer,
    String? state,
    String? district,
    String? season,
    String? crop,
  ) {
    _makePredictionUsecase!.execute(
      observer,
      new MakePredictionParams(state, district, season, crop),
    );
  }

  void fetchStateList(UseCaseObserver observer) {
    _fetchStateListUsecase!.execute(observer);
  }

  void fetchDistrictList(UseCaseObserver observer, String? stateId) {
    _fetchDistrictListUsecase!.execute(
      observer,
      new DistrictListParams(
        stateId,
      ),
    );
  }

  void fetchSeasonsList(
      UseCaseObserver observer, String? state, String? district, String? cropId) {
    _fetchSeasonsListUsecase!.execute(
      observer,
      new FetchSeasonListParams(state, district, cropId),
    );
  }

  void fetchCropList(UseCaseObserver observer, String? state, String? district) {
    _fetchCropListUsecase!.execute(
      observer,
      new FetchCropListParams(state, district),
    );
  }
}
