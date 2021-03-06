import 'package:flutter/material.dart';

import '../../../../core/enums.dart';
import '../prediction_controller.dart';

Widget buildPredictionInitializationView({
  @required PredictionPageController controller,
  @required LoginStatus loginStatus,
}) {
  controller.checkForLoginStatus(status: loginStatus);

  return Container(
    child: Center(
      child: LinearProgressIndicator(),
    ),
  );
}
