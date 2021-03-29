import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/observer.dart';
import '../../accounts/domain/usecase/check_login_status_usecase.dart';
import '../../accounts/domain/usecase/logout_user_usecase.dart';
import '../../profile/domain/usecase/fetch_user_details_usecase.dart';

class HomePagePresenter extends Presenter {
  CheckLoginStatusUsecase _checkLoginStatusUsecase;
  FetchUserDetailsUsecase _fetchUserDetailsUsecase;
  LogoutUserUsecase _logoutUserUsecase;

  HomePagePresenter(
    this._checkLoginStatusUsecase,
    this._fetchUserDetailsUsecase,
    this._logoutUserUsecase,
  );

  @override
  dispose() {
    _checkLoginStatusUsecase.dispose();
    _fetchUserDetailsUsecase.dispose();
    _logoutUserUsecase.dispose();
  }

  void checkLoginStatus(UseCaseObserver observer) {
    _checkLoginStatusUsecase.execute(observer);
  }

  void fetchUserDetails(UseCaseObserver observer) {
    _fetchUserDetailsUsecase.execute(observer);
  }

  void logoutUser(UseCaseObserver observer) {
    _logoutUserUsecase.execute(observer);
  }
}
