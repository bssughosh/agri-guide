import 'package:flutter/material.dart';

import '../../widgets/custom_textfield.dart';
import '../register_controller.dart';

Widget registrationPage3({
  required RegisterPageController controller,
  required double width,
}) {
  // pass, confirm pass
  return Container(
    width: width,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            width: width,
            child: CustomTextField(
              title: 'Password',
              hint: 'Password',
              onChanged: controller.textFieldChanged,
              textController: controller.pass1Text,
              obscureText: true,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: width,
            child: CustomTextField(
              title: 'Confirm Password',
              hint: 'Password',
              onChanged: controller.textFieldChanged,
              textController: controller.pass2Text,
              obscureText: true,
              onSaved: controller.submitButtonPressed,
            ),
          ),
        ],
      ),
    ),
  );
}
