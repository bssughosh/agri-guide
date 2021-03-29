import '../entities/prediction_data_entity.dart';

abstract class AgriGuidePredictionRepository {
  /// A function which makes the prediction for the [state],
  /// [district], [season] and [crop]
  Future<PredictionDataEntity> makePrediction(
    String state,
    String district,
    String season,
    String crop,
  );
}
