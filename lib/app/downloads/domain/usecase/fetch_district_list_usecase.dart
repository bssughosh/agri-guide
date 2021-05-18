import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/fetch_input_repository.dart';

class FetchDistrictListUsecase extends CompletableUseCase<DistrictListParams> {
  final FetchInputRepository? _repository;

  FetchDistrictListUsecase(this._repository);

  @override
  Future<Stream<List?>> buildUseCaseStream(DistrictListParams? params) async {
    StreamController<List?> streamController = StreamController();
    try {
      List? res = await _repository!.getDistrictList(params!._stateId);
      streamController.add(res);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }
    return streamController.stream;
  }
}

class DistrictListParams {
  final String? _stateId;

  DistrictListParams(this._stateId);
}
