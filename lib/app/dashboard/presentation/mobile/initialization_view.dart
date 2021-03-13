import 'package:flutter/material.dart';

import '../dashboard_controller.dart';

Widget buildDashboardInitializationView({
  @required DashboardPageController controller,
}) {
  controller.checkForLoginStatus();
  return Center(
    child: CircularProgressIndicator(),
  );
}
