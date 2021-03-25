import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../../core/enums.dart';
import '../../../core/exceptions.dart';

import '../domain/entities/user_entity.dart';
import '../domain/repositories/firebase_authentication_repository.dart';

class FirebaseAuthenticationRepositoryImpl
    implements FirebaseAuthenticationRepository {
  final String errorCodeWrongPassword = "wrong-password";
  final String errorCodeUserNotFound = "user-not-found";
  final String errorCodeInvalidEmail = "invalid-email";
  final String errorCodeNetworkRequestFailed = "network-request-failed";
  final String errorCodeTooManyRequest = "too-many-requests";
  final String errorCodeWeakPassword = 'weak-password';
  final String errorCodeEmailAlreadyInUse = 'email-already-in-use';

  final String _keyNameFullName = 'name';
  final String _keyNameEmail = 'email';
  final String _keyNameAadhar = 'aadhar';
  final String _keyNameState = 'state';
  final String _keyNameDistrict = 'district';
  final String _keyNameMobile = 'mobile';
  final String _keyNameArea = 'area';
  final String _keyNamePincode = 'pincode';

  static const base_url = String.fromEnvironment(
    'base_url',
    defaultValue: 'https://agri-guide-api.herokuapp.com',
  );

  @override
  Future<void> createNewUser(UserEntity user, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      List<String> _state = await _fetchStateNames(user.state);
      List<String> _district = await _fetchDistNames(user.district);

      CollectionReference users =
          FirebaseFirestore.instance.collection('userData');
      await users.doc(FirebaseAuth.instance.currentUser.uid).set({
        _keyNameFullName: user.name,
        _keyNameMobile: user.mobile,
        _keyNameEmail: user.email,
        _keyNameAadhar: user.aadhar,
        _keyNameArea: user.area,
        _keyNameState: _state[0],
        _keyNameDistrict: _district[0],
        _keyNamePincode: user.pincode,
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == errorCodeWrongPassword) {
        throw RegisterWeakPasswordException();
      } else if (error.code == errorCodeEmailAlreadyInUse) {
        throw RegisterEmailAlreadyInUseException();
      }
    } catch (error) {
      print(error);
      if (FirebaseAuth.instance.currentUser != null) {
        User currentUser = FirebaseAuth.instance.currentUser;
        await currentUser.delete();
      }
      throw RegisterGenericException();
    }
  }

  _fetchStateNames(String stateId) async {
    String url = '$base_url/get_state_value?state_id=$stateId';
    http.Response value = await http.get(Uri.parse(url));
    if (value.statusCode == 400) {
      throw APIBadRequestError();
    } else if (value.statusCode == 403) {
      throw APIForbiddenError();
    } else if (value.statusCode == 404) {
      throw APINotFoundError();
    } else if (value.statusCode == 429) {
      throw APITooManyRequestsError();
    } else if (value.statusCode == 500) {
      throw APIInternalServerError();
    } else if (value.statusCode == 503) {
      throw APIServiceUnavailabeError();
    }
    var data = json.decode(value.body);
    return List<String>.from(data['states']);
  }

  _fetchDistNames(String districtId) async {
    String url = '$base_url/get_dist_value?dist_id=$districtId';
    http.Response value = await http.get(Uri.parse(url));
    if (value.statusCode == 400) {
      throw APIBadRequestError();
    } else if (value.statusCode == 403) {
      throw APIForbiddenError();
    } else if (value.statusCode == 404) {
      throw APINotFoundError();
    } else if (value.statusCode == 429) {
      throw APITooManyRequestsError();
    } else if (value.statusCode == 500) {
      throw APIInternalServerError();
    } else if (value.statusCode == 503) {
      throw APIServiceUnavailabeError();
    }
    var data = json.decode(value.body);
    return List<String>.from(data['dists']);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      FirebaseAuthException firebaseAuthxception = error;
      String errorCode = firebaseAuthxception.code;
      String errorMessage = firebaseAuthxception.message;
      print('ERROR_CODE:$errorCode');
      print('ERROR_MESSAGE:$errorMessage');
      if (errorCode == errorCodeWrongPassword ||
          errorCode == errorCodeUserNotFound ||
          errorCode == errorCodeInvalidEmail) {
        throw LoginInvalidCredentialsException();
      } else if (errorCode == errorCodeNetworkRequestFailed) {
        throw LoginNetworkRequestFailedException();
      } else if (errorCode == errorCodeTooManyRequest) {
        throw LoginTooManyRequestException();
      } else {
        throw LoginGenericException();
      }
    } catch (error) {
      throw LoginGenericException();
    }
  }

  @override
  Future<LoginStatus> checkLoginStatus() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return LoginStatus.LOGGED_IN;
    } else {
      return LoginStatus.LOGGED_OUT;
    }
  }

  @override
  Future<void> logoutUser() async {
    FirebaseAuth.instance.signOut();
  }
}
