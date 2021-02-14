import 'package:agri_guide/app/prediction/data/repositories/agri_guide_prediction_repository_impl.dart';
import 'package:agri_guide/app/prediction/domain/entities/prediction_data_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AgriGuidePredictionRepositoryImpl agriGuidePredictionRepositoryImpl;

  setUp(() {
    agriGuidePredictionRepositoryImpl = AgriGuidePredictionRepositoryImpl();
  });

  group('Prediction Repository Tests', () {
    test('should make predictions', () async {
      expect(
        await agriGuidePredictionRepositoryImpl.makePrediction(
            'Test', 'Test', 'Test', 'Test'),
        isA<PredictionDataEntity>(),
      );
    });
  });
}
