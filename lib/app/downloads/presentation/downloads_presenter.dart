import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/observer.dart';
import '../domain/usecase/fetch_district_list_usecase.dart';
import '../domain/usecase/fetch_state_list_usecase.dart';
import '../domain/usecase/get_required_downloads_usecase.dart';
import '../domain/usecase/get_required_mobile_downloads_usecase.dart';

class DownloadsPagePresenter extends Presenter {
  FetchStateListUsecase _fetchStateListUsecase;
  FetchDistrictListUsecase _fetchDistrictListUsecase;
  GetRequiredDownloadsUsecase _getRequiredDownloadsUsecase;
  GetRequiredMobileDownloadsUsecase _getRequiredMobileDownloadsUsecase;

  DownloadsPagePresenter(
    this._fetchStateListUsecase,
    this._fetchDistrictListUsecase,
    this._getRequiredDownloadsUsecase,
    this._getRequiredMobileDownloadsUsecase,
  );

  @override
  dispose() {
    _fetchStateListUsecase.dispose();
    _fetchDistrictListUsecase.dispose();
    _getRequiredDownloadsUsecase.dispose();
    _getRequiredMobileDownloadsUsecase.dispose();
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

  void getRequiredDownload(
    UseCaseObserver observer,
    List<String> states,
    List<String> dists,
    List<String> yrs,
    List<String> params,
  ) {
    _getRequiredDownloadsUsecase.execute(
        observer, new GetDownloadParams(states, dists, yrs, params));
  }

  void getRequiredDownloadMobile(
    UseCaseObserver observer,
    List<String> states,
    List<String> dists,
    List<String> yrs,
    List<String> params,
  ) {
    _getRequiredMobileDownloadsUsecase.execute(
        observer, new GetDownloadMobileParams(states, dists, yrs, params));
  }
}
