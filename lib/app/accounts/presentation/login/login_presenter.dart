import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../core/observer.dart';
import '../../domain/usecase/login_with_email_and_password_usecase.dart';

class LoginPagePresenter extends Presenter {
  LoginWithEmailAndPasswordUsecase? _loginWithEmailAndPasswordUsecase;
  LoginPagePresenter(this._loginWithEmailAndPasswordUsecase);

  @override
  dispose() {
    _loginWithEmailAndPasswordUsecase!.dispose();
  }

  void loginWithEmailAndPassword(
      UseCaseObserver observer, String email, String password) {
    _loginWithEmailAndPasswordUsecase!.execute(
      observer,
      new LoginParams(email, password),
    );
  }
}
