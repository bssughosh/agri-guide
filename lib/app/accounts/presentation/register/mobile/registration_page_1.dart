import 'package:flutter/material.dart';

import '../../../../../core/app_theme.dart';
import '../register_controller.dart';

Widget registrationPage1({
  @required RegisterPageController controller,
}) {
  // name, email, phone, aadhar
  return Center(
    child: Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Text(
                'Personal Details',
                style: AppTheme.headingBoldText,
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller.nameText,
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: 'Full Name',
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (value) {
                controller.textFieldChanged();
              },
              autofillHints: [AutofillHints.name],
            ),
            SizedBox(height: 5),
            TextField(
              controller: controller.emailText,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: 'Email Address',
                labelText: 'Email Address',
                errorText: controller.isEmailTextFine
                    ? null
                    : 'Please enter a valid email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (value) {
                controller.textFieldChanged();
              },
              autofillHints: [AutofillHints.newUsername],
            ),
            SizedBox(height: 5),
            TextField(
              controller: controller.aadharText,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: 'Aadhar Card Number',
                labelText: 'Aadhar Card Number',
                errorText: controller.isAadharTextFine
                    ? null
                    : 'Please enter an Aadhar card number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (value) {
                controller.textFieldChanged();
              },
            ),
            SizedBox(height: 5),
            TextField(
              controller: controller.phoneText,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                fillColor: Colors.white,
                hintText: 'Mobile Number (optional)',
                labelText: 'Mobile Number',
                errorText: controller.isPhoneTextFine
                    ? null
                    : 'Please enter a valid mobile number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onChanged: (value) {
                controller.textFieldChanged();
              },
              autofillHints: [AutofillHints.telephoneNumber],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    ),
  );
}
