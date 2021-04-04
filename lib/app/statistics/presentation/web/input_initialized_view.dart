import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../statistics_controller.dart';

Widget buildStatisticsInputInitializedViewWeb({
  @required BuildContext context,
  @required StatisticsPageController controller,
}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.4,
    child: WillPopScope(
      onWillPop: () => Future.sync(controller.onWillPopScopePage1),
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
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
                  if (controller.districtList.isNotEmpty) SizedBox(height: 20),
                if (controller.selectedState != null)
                  if (controller.districtList.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 10),
                        child: Text(
                          'District: ',
                          style:
                              AppTheme.headingBoldText.copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                if (controller.selectedState != null)
                  if (controller.districtList.isNotEmpty)
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
                SizedBox(height: 50),
                if (controller.selectedState == null)
                  Image.asset(
                    'assets/select_state.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                if (controller.selectedDistrict == null &&
                    controller.selectedState != null)
                  Image.asset(
                    'assets/select_district.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
