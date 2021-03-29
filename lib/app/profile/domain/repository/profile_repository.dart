import '../../../accounts/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<void> changePassword(String newPassword);

  Future<void> updateUserDetails(UserEntity newDetails);

  Future<UserEntity> fetchUserDetails();
}
