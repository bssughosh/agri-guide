import 'package:flutter/material.dart';

import '../../../../core/enums.dart';
import '../dashboard_controller.dart';

Widget buildDashboardInitializationView({
  @required DashboardPageController controller,
  @required LoginStatus loginStatus,
}) {
  controller.checkForLoginStatus(status: loginStatus);
  return Center(
    child: CircularProgressIndicator(),
  );
}
