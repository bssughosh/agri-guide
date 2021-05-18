import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/fetch_input_repository.dart';

class FetchCropListUsecase extends CompletableUseCase<FetchCropListParams> {
  final FetchInputRepository? _repository;

  FetchCropListUsecase(this._repository);

  @override
  Future<Stream<List?>> buildUseCaseStream(FetchCropListParams? params) async {
    StreamController<List?> streamController = StreamController();
    try {
      List? res = await _repository!.getCrops(
        params!.state,
        params.district,
      );
      streamController.add(res);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }
    return streamController.stream;
  }
}

class FetchCropListParams {
  final String? state;
  final String? district;

  FetchCropListParams(this.state, this.district);
}
