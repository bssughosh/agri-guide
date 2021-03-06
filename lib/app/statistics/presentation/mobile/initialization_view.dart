import 'package:flutter/material.dart';

import '../statistics_controller.dart';

Widget buildStatisticsInitializationViewMobile({
  @required StatisticsPageController controller,
}) {
  controller.fetchStateList();

  return Center(
    child: CircularProgressIndicator(),
  );
}
