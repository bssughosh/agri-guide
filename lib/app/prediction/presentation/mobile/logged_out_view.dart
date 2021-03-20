import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../prediction_controller.dart';
import 'content_body.dart';

Widget buildPredictionLoggedOutView({
  @required bool isWeb,
  @required PredictionPageController controller,
  @required BuildContext context,
}) {
  if (controller.loginStatus == LoginStatus.LOGGED_OUT) {
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'You Must Login to get predictions for your location',
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
    isWeb: isWeb,
    controller: controller,
    context: context,
  );
}
