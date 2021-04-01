import 'package:flutter/material.dart';

import '../register_controller.dart';

Widget registrationPage1({
  @required bool isWeb,
  @required RegisterPageController controller,
}) {
  // state, dist, area
  if (!controller.stateListInitialized) controller.fetchStateList();
  return Container();
}
