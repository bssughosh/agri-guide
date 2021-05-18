import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../../../../core/widgets/custom_button.dart';
import '../dashboard_controller.dart';
import 'content_body.dart';

Widget buildDashboardInitializedViewMobile({
  required LoginStatus loginStatus,
  required DashboardPageController controller,
  required BuildContext context,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  if (loginStatus == LoginStatus.LOGGED_OUT) {
    return Container(
      width: screenWidth,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            Image.asset(
              'assets/login_to_continue.png',
              width: screenWidth * 0.6,
            ),
            SizedBox(height: 50),
            CustomButton(
              isActive: true,
              isOverlayRequired: false,
              onPressed: () {
                controller.navigateToLogin();
              },
              title: 'Login',
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New User?'),
                    SizedBox(width: 10),
                    GestureDetector(
                      child: Text(
                        'Register',
                        style: AppTheme.bodyBoldText.copyWith(
                          decoration: TextDecoration.underline,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                      onTap: () {
                        controller.navigateToRegistration();
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  return contentBody(
    controller: controller,
    context: context,
  );
}
