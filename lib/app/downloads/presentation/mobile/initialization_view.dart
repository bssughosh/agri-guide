import 'package:flutter/material.dart';

import '../downloads_controller.dart';

Widget buildDownloadsInitializationView({
  @required bool isFirstLoad,
  @required bool isWeb,
  @required DownloadsPageController controller,
}) {
  if (isFirstLoad) controller.fetchStateList(isWeb);

  return Container(
    child: Center(
      child: LinearProgressIndicator(),
    ),
  );
}
