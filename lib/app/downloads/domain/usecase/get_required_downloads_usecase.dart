import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/fetch_input_repository.dart';

class GetRequiredDownloadsUsecase
    extends CompletableUseCase<GetDownloadParams> {
  final FetchInputRepository? _repository;

  GetRequiredDownloadsUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(GetDownloadParams? params) async {
    StreamController streamController = StreamController();
    try {
      await _repository!.getRequiredDownloads(
          params!.states, params.dists, params.yrs, params.param);
      print('Download success');
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }
    return streamController.stream;
  }
}

class GetDownloadParams {
  final List<String> states;
  final List<String> dists;
  final List<String> yrs;
  final List<String?> param;

  GetDownloadParams(this.states, this.dists, this.yrs, this.param);
}
