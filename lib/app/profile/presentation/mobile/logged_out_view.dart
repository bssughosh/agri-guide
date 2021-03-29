import 'package:agri_guide/app/profile/presentation/profile_controller.dart';
import 'package:agri_guide/core/app_theme.dart';
import 'package:agri_guide/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

Widget buildProfileLoggedOutViewMobile({
  @required ProfilePageController controller,
  @required BuildContext context,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  return Container(
    width: screenWidth,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40),
          Image.asset(
            'assets/login_to_continue.png',
            width: screenWidth * 0.6,
          ),
          CustomButton(
            isActive: true,
            isOverlayRequired: false,
            onPressed: () {
              controller.navigateToLogin();
            },
            title: 'Login',
          ),
          Container(
            child: Row(
              children: [
                Text('New User?'),
                SizedBox(width: 10),
                GestureDetector(
                  child: Text(
                    'Register',
                    style: AppTheme.bodyBoldText
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                  onTap: () {
                    controller.navigateToRegistration();
                  },
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
