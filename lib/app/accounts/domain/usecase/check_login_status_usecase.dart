import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../core/enums.dart';
import '../repositories/firebase_authentication_repository.dart';

class CheckLoginStatusUsecase extends CompletableUseCase<void> {
  final FirebaseAuthenticationRepository? _repository;

  CheckLoginStatusUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(void params) async {
    StreamController<LoginStatus> streamController = StreamController();
    try {
      LoginStatus status = await _repository!.checkLoginStatus();
      streamController.add(status);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }
    return streamController.stream;
  }
}
