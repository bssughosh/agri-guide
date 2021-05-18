import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/user_entity.dart';
import '../repositories/firebase_authentication_repository.dart';

class CreateNewUserUsecase extends CompletableUseCase<CreateUserParams> {
  final FirebaseAuthenticationRepository? _repository;

  CreateNewUserUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(CreateUserParams? params) async {
    StreamController streamController = StreamController();
    try {
      await _repository!.createNewUser(params!.user, params.password);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }

    return streamController.stream;
  }
}

class CreateUserParams {
  final UserEntity user;
  final String password;

  CreateUserParams(this.user, this.password);
}
