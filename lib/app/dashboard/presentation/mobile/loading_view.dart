import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/app_theme.dart';

Widget buildDashboardLoadingView() {
  return Scaffold(
    body: Center(
      child: SpinKitFoldingCube(color: AppTheme.secondaryColor),
    ),
  );
}
