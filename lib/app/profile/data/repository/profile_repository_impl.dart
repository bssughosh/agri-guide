import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/exceptions.dart';
import '../../../accounts/domain/entities/user_entity.dart';
import '../../domain/repository/profile_repository.dart';

class ProfileRespositoryImpl extends ProfileRepository {
  final String _keyNameFullName = 'name';
  final String _keyNameEmail = 'email';
  final String _keyNameAadhar = 'aadhar';
  final String _keyNameState = 'state';
  final String _keyNameDistrict = 'district';
  final String _keyNameMobile = 'mobile';
  final String _keyNameArea = 'area';
  final String _keyNamePincode = 'pincode';

  /// Key Name `uid`
  Map<String, UserEntity> _userDetails = {};

  final CollectionReference userData =
      FirebaseFirestore.instance.collection('userData');

  @override
  Future<UserEntity?> fetchUserDetails() async {
    User? currentSignedInUser = FirebaseAuth.instance.currentUser;
    if (currentSignedInUser == null) throw UserNotSignedInError();
    if (_userDetails.containsKey(currentSignedInUser.uid))
      return _userDetails[currentSignedInUser.uid];
    DocumentSnapshot userDetails =
        await userData.doc(currentSignedInUser.uid).get();
    UserEntity user = new UserEntity(
      aadhar: userDetails[_keyNameAadhar],
      name: userDetails[_keyNameFullName],
      email: userDetails[_keyNameEmail],
      area: userDetails[_keyNameArea],
      state: userDetails[_keyNameState],
      district: userDetails[_keyNameDistrict],
      mobile: userDetails[_keyNameMobile],
      pincode: userDetails[_keyNamePincode],
    );

    _userDetails[currentSignedInUser.uid] = user;

    return user;
  }

  @override
  Future<void> changePassword(String newPassword) async {
    User currentUser = FirebaseAuth.instance.currentUser!;

    await currentUser.updatePassword(newPassword);
  }

  @override
  Future<void> updateUserDetails(UserEntity newDetails) async {
    User? currentSignedInUser = FirebaseAuth.instance.currentUser;
    if (currentSignedInUser == null) throw UserNotSignedInError();

    await userData.doc(currentSignedInUser.uid).set({
      _keyNameArea: newDetails.area,
      _keyNameDistrict: newDetails.district,
      _keyNameState: newDetails.state,
      _keyNamePincode: newDetails.pincode,
      _keyNameMobile: newDetails.mobile,
      _keyNameFullName: newDetails.name,
      _keyNameEmail: newDetails.email,
      _keyNameAadhar: newDetails.aadhar,
    });

    _deleteCacheData(currentSignedInUser.uid);
  }

  _deleteCacheData(String uid) {
    _userDetails.remove(uid);
  }
}
