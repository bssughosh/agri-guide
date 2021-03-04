import 'package:flutter/material.dart';

/// An entity containing user details
class UserEntity {
  /// Full Name of the User
  final String name;

  /// Email ID of the User
  final String email;

  /// Aadhar Number of the User
  final String aadhar;

  /// Residing State of the User
  final String state;

  /// Residing District of the User
  final String district;

  /// Mobile Number of the User
  final String mobile;

  /// Total Area of the farm of the User
  final String area;

  /// Pincode of the Residing location of the User
  final String pincode;

  UserEntity({
    @required this.name,
    @required this.email,
    @required this.aadhar,
    @required this.state,
    @required this.district,
    @required this.area,
    @required this.pincode,
    this.mobile = '',
  });
}
