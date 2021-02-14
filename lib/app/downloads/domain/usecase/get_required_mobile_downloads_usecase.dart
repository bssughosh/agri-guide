import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/fetch_input_repository.dart';

class GetRequiredMobileDownloadsUsecase
    extends CompletableUseCase<GetDownloadMobileParams> {
  final FetchInputRepository _repository;

  GetRequiredMobileDownloadsUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      GetDownloadMobileParams params) async {
    StreamController streamController = StreamController();
    try {
      await _repository.getRequiredDownloadsMobile(
          params.states, params.dists, params.yrs, params.param);
      print('Download success');
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }
    return streamController.stream;
  }
}

class GetDownloadMobileParams {
  final List<String> states;
  final List<String> dists;
  final List<String> yrs;
  final List<String> param;

  GetDownloadMobileParams(this.states, this.dists, this.yrs, this.param);
}
