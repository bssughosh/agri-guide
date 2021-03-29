import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/app_theme.dart';
import '../profile_controller.dart';

Widget buildProfileInitializationView(
    {@required ProfilePageController controller}) {
  controller.checkForLoginStatus();

  return Container(
    margin: EdgeInsets.only(top: 200),
    child: Center(
      child: SpinKitFoldingCube(color: AppTheme.secondaryColor),
    ),
  );
}
