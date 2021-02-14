import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/firebase_authentication_repository.dart';

class LoginWithEmailAndPasswordUsecase extends CompletableUseCase<LoginParams> {
  final FirebaseAuthenticationRepository _repository;

  LoginWithEmailAndPasswordUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(LoginParams params) async {
    StreamController streamController = StreamController();
    try {
      await _repository.signInWithEmailAndPassword(
          params.email, params.password);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }

    return streamController.stream;
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams(this.email, this.password);
}
