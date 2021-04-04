import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../profile_controller.dart';

Widget buildProfileLoggedOutViewWeb({
  @required ProfilePageController controller,
  @required BuildContext context,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  return Container(
    width: screenWidth * 0.25,
    margin: EdgeInsets.all(10),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Image.asset(
              'assets/login_to_continue.png',
              width: screenWidth * 0.22,
            ),
          ),
          SizedBox(height: 20),
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
