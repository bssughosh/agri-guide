import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/fetch_input_repository.dart';

class FetchSeasonsListUsecase
    extends CompletableUseCase<FetchSeasonListParams> {
  final FetchInputRepository? _repository;

  FetchSeasonsListUsecase(this._repository);

  @override
  Future<Stream<List?>> buildUseCaseStream(FetchSeasonListParams? params) async {
    StreamController<List?> streamController = StreamController();
    try {
      List? res = await _repository!.getSeasons(
        params!.state,
        params.district,
        params.cropId,
      );
      streamController.add(res);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }
    return streamController.stream;
  }
}

class FetchSeasonListParams {
  final String? state;
  final String? district;
  final String? cropId;

  FetchSeasonListParams(this.state, this.district, this.cropId);
}
