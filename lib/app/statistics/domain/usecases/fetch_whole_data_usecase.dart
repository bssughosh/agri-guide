import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/statistics_entity.dart';
import '../repositories/statistics_repository.dart';

class FetchWholeDataUsecase extends CompletableUseCase<FetchWholeDataParams> {
  StatisticsRepository _repository;

  FetchWholeDataUsecase(this._repository);

  @override
  Future<Stream<StatisticsEntity>> buildUseCaseStream(
      FetchWholeDataParams params) async {
    StreamController<StatisticsEntity> streamController = StreamController();
    try {
      StatisticsEntity statisticsEntity = await _repository.fetchWholeData(
        params.state,
        params.district,
      );
      streamController.add(statisticsEntity);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }

    return streamController.stream;
  }
}

class FetchWholeDataParams {
  final String state;
  final String district;

  FetchWholeDataParams(this.state, this.district);
}
