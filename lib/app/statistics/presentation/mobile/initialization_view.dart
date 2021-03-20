import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/app_theme.dart';
import '../statistics_controller.dart';

Widget buildStatisticsInitializationViewMobile({
  @required StatisticsPageController controller,
}) {
  controller.fetchStateList();

  return Container(
    margin: EdgeInsets.only(top: 100),
    child: Center(
      child: SpinKitFoldingCube(color: AppTheme.chipBackground),
    ),
  );
}
