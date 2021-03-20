import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../prediction_controller.dart';

Widget buildPredictionInputInitializedViewMobile({
  @required PredictionPageController controller,
  @required BuildContext context,
}) {
  if (!controller.stateListInitialized) controller.fetchStateList();

  bool _showLoadingIndicator = controller.stateListLoading ||
      (!controller.stateListLoading && controller.selectedState != null) ||
      (controller.areCropsAvailable &&
          (controller.seasonListLoading || controller.cropListLoading));
  bool _showStateList = !controller.stateListLoading;
  bool _showDistrictList =
      controller.selectedState != null && !controller.districtListLoading;

  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    child: SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Text(
              'Agricultural Location Details',
              style: AppTheme.headingBoldText,
            ),
          ),
          SizedBox(height: 20),
          if (_showStateList)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 10),
                child: Text(
                  'State: ',
                  style: AppTheme.headingBoldText.copyWith(fontSize: 17),
                ),
              ),
            ),
          if (_showStateList) SizedBox(height: 5),
          if (_showStateList)
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
          if (_showDistrictList) SizedBox(height: 20),
          if (_showDistrictList)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 10),
                child: Text(
                  'District: ',
                  style: AppTheme.headingBoldText.copyWith(fontSize: 17),
                ),
              ),
            ),
          if (_showDistrictList) SizedBox(height: 5),
          if (_showDistrictList)
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
        ],
      ),
    ),
  );
}
