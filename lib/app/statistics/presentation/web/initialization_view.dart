import 'package:flutter/material.dart';

import '../statistics_controller.dart';

Widget buildStatisticsInitializationViewWeb({
  @required StatisticsPageController controller,
}) {
  controller.fetchStateList();

  return LinearProgressIndicator();
}
