import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../accounts/domain/entities/user_entity.dart';
import '../repository/profile_repository.dart';

class UpdateUserDetailsUsecase
    extends CompletableUseCase<UpdateUserDetailsParams> {
  ProfileRepository _repository;

  UpdateUserDetailsUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      UpdateUserDetailsParams params) async {
    StreamController streamController = new StreamController();

    try {
      await _repository.updateUserDetails(params.userEntity);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }

    return streamController.stream;
  }
}

class UpdateUserDetailsParams {
  final UserEntity userEntity;

  UpdateUserDetailsParams({@required this.userEntity});
}
