import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../dashboard_controller.dart';
import 'content_body.dart';

Widget buildDashboardInitializedViewWeb({
  @required LoginStatus loginStatus,
  @required DashboardPageController controller,
  @required BuildContext context,
}) {
  if (loginStatus == LoginStatus.LOGGED_OUT) {
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Please Login to get most out of the app',
                style: AppTheme.headingBoldText,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextButton(
                child: Text(
                  'Login / Register',
                  style: AppTheme.navigationTabSelectedTextStyle,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      AppTheme.navigationSelectedColor),
                ),
                onPressed: () {
                  controller.navigateToLogin();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  return contentBody(
    controller: controller,
    context: context,
  );
}
