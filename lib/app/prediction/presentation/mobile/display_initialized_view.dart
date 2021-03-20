import 'package:flutter/material.dart';

import '../prediction_controller.dart';

Widget buildPredictionDisplayInitializedViewMobile({
  @required PredictionPageController controller,
  @required BuildContext context,
}) {
  return WillPopScope(
    onWillPop: () => Future.sync(controller.onWillPopScopePage2),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    ),
  );
}
