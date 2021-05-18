import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repository/profile_repository.dart';

class ChangePasswordUsecase extends CompletableUseCase<ChangePasswordParams> {
  ProfileRepository? _repository;

  ChangePasswordUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(ChangePasswordParams? params) async {
    StreamController streamController = new StreamController();

    try {
      await _repository!.changePassword(params!.newPassword);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }

    return streamController.stream;
  }
}

class ChangePasswordParams {
  final String newPassword;

  ChangePasswordParams({required this.newPassword});
}
