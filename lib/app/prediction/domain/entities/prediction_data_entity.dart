/// An entity containing predicted values
class PredictionDataEntity {
  /// 2020 monthly predictions for temperature
  final List<String> temperature;

  /// 2020 monthly predictions for rainfall
  final List<String> rainfall;

  /// 2020 monthly predictions for humidity
  final List<String> humidity;

  /// 2020 yield prediction for area set as 10
  final double predictedYield;

  PredictionDataEntity({
    required this.temperature,
    required this.rainfall,
    required this.humidity,
    required this.predictedYield,
  });
}
