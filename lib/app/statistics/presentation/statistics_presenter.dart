import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/observer.dart';
import '../../downloads/domain/usecase/fetch_district_list_usecase.dart';
import '../../downloads/domain/usecase/fetch_state_list_usecase.dart';
import '../domain/usecases/fetch_whole_data_usecase.dart';

class StatisticsPagePresenter extends Presenter {
  FetchStateListUsecase _fetchStateListUsecase;
  FetchDistrictListUsecase _fetchDistrictListUsecase;
  FetchWholeDataUsecase _fetchWholeDataUsecase;

  StatisticsPagePresenter(
    this._fetchDistrictListUsecase,
    this._fetchStateListUsecase,
    this._fetchWholeDataUsecase,
  );

  @override
  dispose() {
    _fetchWholeDataUsecase.dispose();
    _fetchStateListUsecase.dispose();
    _fetchDistrictListUsecase.dispose();
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

  void fetchWholeData(UseCaseObserver observer, String state, String district) {
    _fetchWholeDataUsecase.execute(
      observer,
      new FetchWholeDataParams(
        state,
        district,
      ),
    );
  }
}
