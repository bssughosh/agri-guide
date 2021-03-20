import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/app_theme.dart';
import '../downloads_controller.dart';

Widget buildDownloadsInitializationView({
  @required bool isFirstLoad,
  @required bool isWeb,
  @required DownloadsPageController controller,
}) {
  if (isFirstLoad) controller.fetchStateList(isWeb);

  return Container(
    margin: EdgeInsets.only(top: 100),
    child: Center(
      child: SpinKitFoldingCube(color: AppTheme.chipBackground),
    ),
  );
}
