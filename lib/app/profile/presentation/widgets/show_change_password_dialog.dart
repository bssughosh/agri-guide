import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/app_theme.dart';
import '../profile_controller.dart';
import 'custom_textfield.dart';

Future<void> showChangePasswordDialog({
  @required BuildContext context,
  @required ProfilePageController controller,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Text(
          'Change Password',
          style: AppTheme.headingBoldText.copyWith(fontSize: 16),
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                textController: controller.pass1,
                title: 'Password',
                hint: 'Password',
                onChanged: controller.passwordFieldChanged,
                isEnabled: true,
                obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextField(
                textController: controller.pass2,
                title: 'Confirm Password',
                hint: 'Confirm Password',
                onChanged: controller.passwordFieldChanged,
                isEnabled: true,
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              if (controller.pass1.text == controller.pass2.text) {
                Navigator.pop(context);
                controller.changePassword();
              } else {
                Fluttertoast.showToast(msg: 'The passwords do not match');
              }
            },
          ),
        ],
      );
    },
  );
}
