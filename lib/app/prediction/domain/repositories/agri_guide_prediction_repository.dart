import '../../../accounts/domain/entities/user_entity.dart';
import '../entities/prediction_data_entity.dart';

abstract class AgriGuidePredictionRepository {
  /// A function to fetch the user details from the firestore
  /// and save in a [UserEntity]
  Future<UserEntity> fetchUserDetails();

  /// A function which makes the prediction for the [state],
  /// [district], [season] and [crop]
  Future<PredictionDataEntity> makePrediction(
    String state,
    String district,
    String season,
    String crop,
  );
}
