import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/app_theme.dart';
import '../prediction_controller.dart';

Widget buildPredictionInitializationView({
  @required PredictionPageController controller,
}) {
  controller.checkForLoginStatus();

  return Container(
    margin: EdgeInsets.only(top: 100),
    child: Center(
      child: SpinKitFoldingCube(color: AppTheme.chipBackground),
    ),
  );
}
