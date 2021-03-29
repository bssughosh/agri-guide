import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_secondary_button.dart';
import '../profile_controller.dart';
import 'show_change_password_dialog.dart';

Widget bottomActionsWidget({
  @required ProfilePageController controller,
  @required BuildContext context,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      CustomSecondaryButton(
        isActive: true,
        title: 'Change Password',
        onPressed: () {
          showChangePasswordDialog(context: context, controller: controller);
        },
      ),
      CustomButton(
        isActive: true,
        isOverlayRequired: false,
        onPressed: () {
          controller.logoutUser();
        },
        title: 'Logout',
      ),
    ],
  );
}
