import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../profile_controller.dart';
import '../widgets/bottom_actions_widget.dart';
import '../widgets/custom_textfield.dart';

Widget buildProfileLoggedInViewWeb({
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
              padding: const EdgeInsets.only(left: 5, bottom: 5),
              child: Text(
                'State: ',
                style: AppTheme.headingBoldText.copyWith(fontSize: 15),
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
              padding: const EdgeInsets.only(left: 5, bottom: 5),
              child: Text(
                'District: ',
                style: AppTheme.headingBoldText.copyWith(fontSize: 15),
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
          SizedBox(height: 20),
          if (controller.isProfileUpdated)
            CustomButton(
              isActive: true,
              title: 'Update Details',
              onPressed: () {
                controller.updateUserDetails();
              },
              isOverlayRequired: false,
            ),
          if (!controller.isProfileUpdated)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child:
                  bottomActionsWidget(controller: controller, context: context),
            ),
        ],
      ),
    ),
  );
}
