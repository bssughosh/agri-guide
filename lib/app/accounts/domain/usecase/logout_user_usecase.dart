import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/firebase_authentication_repository.dart';

class LogoutUserUsecase extends CompletableUseCase<void> {
  final FirebaseAuthenticationRepository? _repository;

  LogoutUserUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(void params) async {
    StreamController streamController = StreamController();
    try {
      await _repository!.logoutUser();
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }

    return streamController.stream;
  }
}
