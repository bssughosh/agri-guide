import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/app_theme.dart';
import '../dashboard_controller.dart';

Widget buildDashboardInitializationView({
  @required DashboardPageController controller,
}) {
  controller.checkForLoginStatus();
  return Container(
    margin: EdgeInsets.only(top: 200),
    child: Center(
      child: SpinKitFoldingCube(color: AppTheme.secondaryColor),
    ),
  );
}
