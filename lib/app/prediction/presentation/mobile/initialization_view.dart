import 'package:flutter/material.dart';

import '../prediction_controller.dart';

Widget buildPredictionInitializationView({
  @required PredictionPageController controller,
}) {
  controller.checkForLoginStatus();

  return Container(
    child: Center(
      child: LinearProgressIndicator(),
    ),
  );
}
