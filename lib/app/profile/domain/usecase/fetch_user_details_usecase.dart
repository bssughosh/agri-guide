import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../accounts/domain/entities/user_entity.dart';
import '../repository/profile_repository.dart';

class FetchUserDetailsUsecase extends CompletableUseCase<void> {
  final ProfileRepository? _repository;

  FetchUserDetailsUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(void params) async {
    StreamController<UserEntity?> streamController = StreamController();
    try {
      UserEntity? user = await _repository!.fetchUserDetails();
      streamController.add(user);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }

    return streamController.stream;
  }
}
