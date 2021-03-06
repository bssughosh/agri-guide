import 'package:agri_guide/app/prediction/presentation/prediction_controller.dart';
import 'package:flutter/material.dart';

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
