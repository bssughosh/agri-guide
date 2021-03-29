import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../profile_controller.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/show_change_password_dialog.dart';

Widget buildProfileLoggedInViewMobile({
  @required ProfilePageController controller,
  @required BuildContext context,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  return Container(
    width: screenWidth * 0.9,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          CustomTextField(
            textController: controller.name,
            title: 'Name',
            hint: 'Full Name',
            onChanged: controller.textFieldChanged,
            isEnabled: false,
          ),
          SizedBox(height: 10),
          CustomTextField(
            textController: controller.email,
            title: 'Email Id',
            hint: 'Email Id',
            onChanged: controller.textFieldChanged,
            isEnabled: false,
          ),
          SizedBox(height: 10),
          CustomButton(
            isActive: true,
            isOverlayRequired: false,
            onPressed: () {
              showChangePasswordDialog(
                  context: context, controller: controller);
            },
            title: 'Change Password',
          ),
          SizedBox(height: 10),
          CustomTextField(
            textController: controller.aadhar,
            title: 'Aadhar Card Number',
            hint: 'Adhar card',
            onChanged: controller.textFieldChanged,
            isEnabled: false,
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 10),
              child: Text(
                'State: ',
                style: AppTheme.headingBoldText.copyWith(fontSize: 17),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            child: CustomDropdown(
              hintText: 'Select State',
              itemsList: controller.stateItems(),
              selectedItem: controller.selectedState,
              onChanged: (String newValue) {
                controller.selectedState = newValue;
                controller.selectedStateChange();
              },
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 10),
              child: Text(
                'District: ',
                style: AppTheme.headingBoldText.copyWith(fontSize: 17),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            child: CustomDropdown(
              hintText: 'Select District',
              itemsList: controller.districtItems(),
              selectedItem: controller.selectedDistrict,
              onChanged: (String newValue) {
                controller.selectedDistrict = newValue;
                controller.selectedDistrictChange();
              },
            ),
          ),
          SizedBox(height: 10),
          CustomTextField(
            textController: controller.pincode,
            title: 'Pincode',
            hint: 'Pincode',
            onChanged: controller.textFieldChanged,
            isEnabled: true,
          ),
          SizedBox(height: 10),
          CustomTextField(
            textController: controller.area,
            title: 'Area of Land',
            hint: 'Area (acres)',
            onChanged: controller.textFieldChanged,
            isEnabled: true,
          ),
          if (controller.isProfileUpdated) SizedBox(height: 20),
          if (controller.isProfileUpdated)
            CustomButton(
              isActive: true,
              title: 'Update Details',
              onPressed: () {
                controller.updateUserDetails();
              },
              isOverlayRequired: false,
            ),
          SizedBox(height: 50),
        ],
      ),
    ),
  );
}
