import 'package:flutter/material.dart';

import '../../../../../core/app_theme.dart';
import '../register_controller.dart';

Widget registrationPage3({
  @required RegisterPageController controller,
}) {
  // pass, confirm pass
  return Center(
    child: Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                'Login Credentials',
                style: AppTheme.headingBoldText,
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller.pass1Text,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: 'Enter Password',
                labelText: 'Password',
                errorText: controller.doBothPassMatch
                    ? null
                    : 'Both the passwords should match',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (value) {
                controller.textFieldChanged();
              },
              autofillHints: [AutofillHints.newPassword],
            ),
            SizedBox(height: 5),
            TextField(
              controller: controller.pass2Text,
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: 'Confirm Password',
                labelText: 'Confirm Password',
                errorText: controller.doBothPassMatch
                    ? null
                    : 'Both the passwords should match',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (value) {
                controller.textFieldChanged();
              },
              autofillHints: [AutofillHints.newPassword],
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    ),
  );
}
