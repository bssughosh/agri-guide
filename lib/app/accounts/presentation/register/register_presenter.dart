import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../core/observer.dart';
import '../../../downloads/domain/usecase/fetch_district_list_usecase.dart';
import '../../../downloads/domain/usecase/fetch_state_list_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/create_new_user_usecase.dart';

class RegisterPagePresenter extends Presenter {
  CreateNewUserUsecase? _createNewUserUsecase;
  FetchStateListUsecase? _fetchStateListUsecase;
  FetchDistrictListUsecase? _fetchDistrictListUsecase;

  RegisterPagePresenter(
    this._createNewUserUsecase,
    this._fetchStateListUsecase,
    this._fetchDistrictListUsecase,
  );

  @override
  dispose() {
    _createNewUserUsecase!.dispose();
    _fetchStateListUsecase!.dispose();
    _fetchDistrictListUsecase!.dispose();
  }

  void createNewUser(
      UseCaseObserver observer, UserEntity user, String password) {
    _createNewUserUsecase!.execute(
        observer, new CreateUserParams(user, password));
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
}
