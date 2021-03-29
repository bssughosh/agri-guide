import 'package:agri_guide/app/accounts/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<void> changePassword(String newPassword);

  Future<void> updateUserDetails();

  /// A function to fetch the user details from the firestore
  /// and save in a [UserEntity]
  Future<UserEntity> fetchUserDetails();
}
