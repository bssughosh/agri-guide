import 'dart:async';

import 'package:agri_guide/app/statistics/domain/entities/yield_statistics_entity.dart';
import 'package:agri_guide/app/statistics/domain/repositories/statistics_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class FetchYieldStatisticsUsecase
    extends CompletableUseCase<FetchYieldStatisticsParams> {
  StatisticsRepository _repository;

  FetchYieldStatisticsUsecase(this._repository);

  @override
  Future<Stream<YieldStatisticsEntity>> buildUseCaseStream(
      FetchYieldStatisticsParams params) async {
    StreamController<YieldStatisticsEntity> streamController =
        new StreamController();

    try {
      YieldStatisticsEntity yieldStatisticsEntity =
          await _repository.fetchYieldStatisticsData(
        params.state,
        params.district,
        params.crop,
        params.season,
      );
      streamController.add(yieldStatisticsEntity);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }

    return streamController.stream;
  }
}

class FetchYieldStatisticsParams {
  final String state;
  final String district;
  final String crop;
  final String season;

  FetchYieldStatisticsParams({
    @required this.state,
    @required this.district,
    @required this.crop,
    @required this.season,
  });
}
