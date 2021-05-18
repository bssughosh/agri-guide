import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/observer.dart';
import '../../downloads/domain/usecase/fetch_crop_list_usecase.dart';
import '../../downloads/domain/usecase/fetch_district_list_usecase.dart';
import '../../downloads/domain/usecase/fetch_seasons_list_usecase.dart';
import '../../downloads/domain/usecase/fetch_state_list_usecase.dart';
import '../domain/usecases/fetch_whole_data_usecase.dart';
import '../domain/usecases/fetch_yield_statistics_usecase.dart';

class StatisticsPagePresenter extends Presenter {
  FetchStateListUsecase? _fetchStateListUsecase;
  FetchDistrictListUsecase? _fetchDistrictListUsecase;
  FetchWholeDataUsecase? _fetchWholeDataUsecase;
  FetchSeasonsListUsecase? _fetchSeasonsListUsecase;
  FetchCropListUsecase? _fetchCropListUsecase;
  FetchYieldStatisticsUsecase? _fetchYieldStatisticsUsecase;

  StatisticsPagePresenter(
    this._fetchDistrictListUsecase,
    this._fetchStateListUsecase,
    this._fetchWholeDataUsecase,
    this._fetchSeasonsListUsecase,
    this._fetchCropListUsecase,
    this._fetchYieldStatisticsUsecase,
  );

  @override
  dispose() {
    _fetchWholeDataUsecase!.dispose();
    _fetchStateListUsecase!.dispose();
    _fetchDistrictListUsecase!.dispose();
    _fetchSeasonsListUsecase!.dispose();
    _fetchCropListUsecase!.dispose();
    _fetchYieldStatisticsUsecase!.dispose();
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

  void fetchWholeData(UseCaseObserver observer, String? state, String? district) {
    _fetchWholeDataUsecase!.execute(
      observer,
      new FetchWholeDataParams(
        state,
        district,
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

  void fetchYieldStatistics(UseCaseObserver observer, String? state,
      String? district, String? cropId, String? season) {
    _fetchYieldStatisticsUsecase!.execute(
      observer,
      new FetchYieldStatisticsParams(
          crop: cropId, state: state, district: district, season: season),
    );
  }
}
