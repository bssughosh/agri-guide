import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/fetch_input_repository.dart';

class FetchStateListUsecase extends CompletableUseCase<void> {
  final FetchInputRepository _repository;

  FetchStateListUsecase(this._repository);

  @override
  Future<Stream<List>> buildUseCaseStream(params) async {
    StreamController<List> streamController = StreamController();
    try {
      List res = await _repository.getStateList();
      streamController.add(res);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }
    return streamController.stream;
  }
}
