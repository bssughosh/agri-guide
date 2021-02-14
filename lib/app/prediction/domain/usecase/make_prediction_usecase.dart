import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/prediction_data_entity.dart';
import '../repositories/agri_guide_prediction_repository.dart';

class MakePredictionUsecase extends CompletableUseCase<MakePredictionParams> {
  final AgriGuidePredictionRepository _repository;

  MakePredictionUsecase(this._repository);

  @override
  Future<Stream<PredictionDataEntity>> buildUseCaseStream(
      MakePredictionParams params) async {
    StreamController<PredictionDataEntity> streamController =
        StreamController();
    try {
      PredictionDataEntity predictionDataEntity =
          await _repository.makePrediction(
        params.state,
        params.district,
        params.season,
        params.crop,
      );
      streamController.add(predictionDataEntity);
      streamController.close();
    } catch (error) {
      streamController.addError(error);
    }

    return streamController.stream;
  }
}

class MakePredictionParams {
  final String state;
  final String district;
  final String season;
  final String crop;

  MakePredictionParams(this.state, this.district, this.season, this.crop);
}
