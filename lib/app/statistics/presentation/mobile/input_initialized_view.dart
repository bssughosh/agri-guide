import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../statistics_controller.dart';

Widget buildStatisticsInputInitializedViewMobile({
  @required BuildContext context,
  @required StatisticsPageController controller,
}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    child: WillPopScope(
      onWillPop: () => Future.sync(controller.onWillPopScopePage1),
      child: Center(
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
                SizedBox(height: 20),
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
                if (controller.selectedState != null)
                  if (controller.districtListLoading)
                    CircularProgressIndicator(),
                if (controller.selectedState != null)
                  if (!controller.districtListLoading) SizedBox(height: 20),
                if (controller.selectedState != null)
                  if (!controller.districtListLoading)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, bottom: 10),
                        child: Text(
                          'District: ',
                          style:
                              AppTheme.headingBoldText.copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                if (controller.selectedState != null)
                  if (!controller.districtListLoading) SizedBox(height: 5),
                if (controller.selectedState != null)
                  if (!controller.districtListLoading)
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
                SizedBox(
                  height: 20,
                ),
                if (controller.selectedState != null &&
                    controller.selectedDistrict != null)
                  Center(
                    child: CustomButton(
                      title: 'Submit',
                      isActive: true,
                      onPressed: () {
                        controller.proceedToStatisticsDisplay();
                      },
                      isOverlayRequired: true,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
