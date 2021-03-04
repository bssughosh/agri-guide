import '../../../../core/enums.dart';
import '../entities/user_entity.dart';

abstract class FirebaseAuthenticationRepository {
  /// A function to sign in a user using email and password as the credentials
  Future<void> signInWithEmailAndPassword(String email, String password);

  /// A function which creates a new User by first creating a user in firebase
  /// auth and then saving the rest of the details on the cloud firestore
  Future<void> createNewUser(UserEntity user, String password);

  /// A function which checks the login status of the user and either returns
  /// [LoginStatus.LOGGED_IN] or [LoginStatus.LOGGED_OUT]
  Future<LoginStatus> checkLoginStatus();

  /// A function which logs out the logged in user
  Future<void> logoutUser();
}
