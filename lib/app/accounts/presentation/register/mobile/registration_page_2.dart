import 'package:flutter/material.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/enums.dart';
import '../register_controller.dart';
import '../widgets/location_selection_bar.dart';
import '../widgets/location_selection_card.dart';

Widget registrationPage2({
  @required bool isWeb,
  @required RegisterPageController controller,
}) {
  // state, dist, area
  if (!controller.stateListInitialized) controller.fetchStateList();
  return Container(
    child: Stack(
      children: [
        Center(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Agricultural Location Details',
                      style: AppTheme.headingBoldText,
                    ),
                  ),
                  SizedBox(height: 15),
                  if (controller.stateListLoading) CircularProgressIndicator(),
                  if (!controller.stateListLoading)
                    LocationSelectionBar(
                      controller: controller,
                      selectionListType: SelectionListType.STATE,
                      isWeb: isWeb,
                    ),
                  if (!controller.stateListLoading &&
                      controller.selectedState != '')
                    if (controller.districtListLoading)
                      CircularProgressIndicator(),
                  if (!controller.stateListLoading &&
                      controller.selectedState != '')
                    if (!controller.districtListLoading)
                      LocationSelectionBar(
                        controller: controller,
                        selectionListType: SelectionListType.DISTRICT,
                        isWeb: isWeb,
                      ),
                  if (controller.selectedState != '' &&
                      controller.selectedDistrict != '')
                    TextField(
                      controller: controller.pincodeText,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'Pincode',
                        labelText: 'Pincode',
                        errorText: controller.isPincodeTextFine
                            ? null
                            : 'Please enter a pincode',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (value) {
                        controller.textFieldChanged();
                      },
                    ),
                  if (controller.selectedState != '' &&
                      controller.selectedDistrict != '')
                    TextField(
                      controller: controller.areaText,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: 'Area of the plot (acres)',
                        labelText: 'Area (acres)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onChanged: (value) {
                        controller.textFieldChanged();
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
        if (controller.isStateFilterClicked)
          Center(
            child: LocationSelectionCard(
              controller: controller,
              selectionListType: SelectionListType.STATE,
              isWeb: isWeb,
            ),
          ),
        if (controller.isDistrictFilterClicked)
          Center(
            child: LocationSelectionCard(
              controller: controller,
              selectionListType: SelectionListType.DISTRICT,
              isWeb: isWeb,
            ),
          ),
      ],
    ),
  );
}
