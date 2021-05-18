import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../prediction_controller.dart';

Widget buildPredictionLoggedOutViewMobile({
  required PredictionPageController controller,
  required BuildContext context,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
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
