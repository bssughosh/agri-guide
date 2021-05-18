import 'package:flutter/material.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';
import '../register_controller.dart';

Widget registrationPage1({
  required RegisterPageController controller,
  required double width,
}) {
  // state, dist, area, pincode
  return Container(
    width: width,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: Text(
                'State: ',
                style: AppTheme.headingBoldText.copyWith(fontSize: 17),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: width,
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
          if (controller.selectedState != null) SizedBox(height: 10),
          if (controller.selectedState != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 5),
                child: Text(
                  'District: ',
                  style: AppTheme.headingBoldText.copyWith(fontSize: 17),
                ),
              ),
            ),
          if (controller.selectedState != null) SizedBox(height: 5),
          if (controller.selectedState != null)
            Container(
              width: width,
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
          if (controller.selectedDistrict != null &&
              controller.selectedState != null)
            SizedBox(height: 10),
          if (controller.selectedDistrict != null &&
              controller.selectedState != null)
            Container(
              width: width,
              child: CustomTextField(
                title: 'Area',
                hint: 'Area (in acres)',
                onChanged: controller.textFieldChanged,
                textController: controller.areaText,
                textInputType: TextInputType.number,
              ),
            ),
          if (controller.selectedDistrict != null &&
              controller.selectedState != null)
            SizedBox(height: 10),
          if (controller.selectedDistrict != null &&
              controller.selectedState != null)
            Container(
              width: width,
              child: CustomTextField(
                title: 'Pincode',
                hint: 'Pincode',
                onChanged: controller.textFieldChanged,
                textController: controller.pincodeText,
                textInputType: TextInputType.number,
                onSaved: controller.nextButtonPressed,
              ),
            ),
        ],
      ),
    ),
  );
}
