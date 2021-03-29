import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/observer.dart';
import '../../accounts/domain/entities/user_entity.dart';
import '../../accounts/domain/usecase/check_login_status_usecase.dart';
import '../../accounts/domain/usecase/logout_user_usecase.dart';
import '../../downloads/domain/usecase/fetch_district_list_usecase.dart';
import '../../downloads/domain/usecase/fetch_state_list_usecase.dart';
import '../domain/usecase/change_password_usecase.dart';
import '../domain/usecase/fetch_user_details_usecase.dart';
import '../domain/usecase/update_user_details_usecase.dart';

class ProfilePagePresenter extends Presenter {
  FetchUserDetailsUsecase _fetchUserDetailsUsecase;
  ChangePasswordUsecase _changePasswordUsecase;
  UpdateUserDetailsUsecase _updateUserDetailsUsecase;
  CheckLoginStatusUsecase _checkLoginStatusUsecase;
  FetchStateListUsecase _fetchStateListUsecase;
  FetchDistrictListUsecase _fetchDistrictListUsecase;
  LogoutUserUsecase _logoutUserUsecase;

  ProfilePagePresenter(
    this._changePasswordUsecase,
    this._fetchUserDetailsUsecase,
    this._updateUserDetailsUsecase,
    this._checkLoginStatusUsecase,
    this._fetchStateListUsecase,
    this._fetchDistrictListUsecase,
    this._logoutUserUsecase,
  );

  @override
  dispose() {
    _fetchUserDetailsUsecase.dispose();
    _changePasswordUsecase.dispose();
    _updateUserDetailsUsecase.dispose();
    _fetchStateListUsecase.dispose();
    _fetchDistrictListUsecase.dispose();
    _checkLoginStatusUsecase.dispose();
    _logoutUserUsecase.dispose();
  }

  void checkLoginStatus(UseCaseObserver observer) {
    _checkLoginStatusUsecase.execute(observer);
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

  void updateUserDetails(UseCaseObserver observer, UserEntity userEntity) {
    _updateUserDetailsUsecase.execute(
      observer,
      new UpdateUserDetailsParams(userEntity: userEntity),
    );
  }

  void changePassword(UseCaseObserver observer, String newPassword) {
    _changePasswordUsecase.execute(
      observer,
      new ChangePasswordParams(newPassword: newPassword),
    );
  }

  void logoutUser(UseCaseObserver observer) {
    _logoutUserUsecase.execute(observer);
  }
}
