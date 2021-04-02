import 'package:flutter/material.dart';

import '../../widgets/custom_textfield.dart';
import '../register_controller.dart';

Widget registrationPage2({
  @required RegisterPageController controller,
  @required double width,
}) {
  // name, email, phone, aadhar
  return Container(
    width: width,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            width: width,
            child: CustomTextField(
              title: 'Name',
              hint: 'Full Name',
              onChanged: controller.textFieldChanged,
              textController: controller.nameText,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: width,
            child: CustomTextField(
              title: 'Email',
              hint: 'Email ID',
              onChanged: controller.textFieldChanged,
              textController: controller.emailText,
              textInputType: TextInputType.emailAddress,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: width,
            child: CustomTextField(
              title: 'Aadhar Card Number',
              hint: '12 digit Aadhar card number',
              onChanged: controller.textFieldChanged,
              textController: controller.aadharText,
              textInputType: TextInputType.number,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: width,
            child: CustomTextField(
              title: 'Phone Number',
              hint: '10 digit mobile number',
              onChanged: controller.textFieldChanged,
              textController: controller.phoneText,
              textInputType: TextInputType.phone,
            ),
          ),
        ],
      ),
    ),
  );
}
