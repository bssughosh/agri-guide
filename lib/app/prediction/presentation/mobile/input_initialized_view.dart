import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../prediction_controller.dart';
import '../widgets/crops_column_widget.dart';
import '../widgets/range_column_widget.dart';
import '../widgets/seasons_column_widget.dart';

Widget buildPredictionInputInitializedViewMobile({
  @required PredictionPageController controller,
  @required BuildContext context,
}) {
  if (!controller.stateListInitialized) controller.fetchStateList();

  bool _showStateList = !controller.stateListLoading;
  bool _showDistrictList =
      controller.selectedState != null && !controller.districtListLoading;
  bool _showSeasonsList = controller.areCropsAvailable &&
      !controller.seasonListLoading &&
      controller.selectedCrop != null &&
      controller.yieldPredictionRequired;
  bool _showCropsList = controller.areCropsAvailable &&
      !controller.cropListLoading &&
      controller.selectedDistrict != null &&
      controller.yieldPredictionRequired;
  bool _showRadioButton = !controller.cropListLoading &&
      controller.areCropsAvailable &&
      controller.selectedDistrict != null;
  bool _showRangeWidget = (!controller.areCropsAvailable &&
          !controller.cropListLoading &&
          controller.selectedDistrict != null) ||
      (controller.areCropsAvailable && !controller.yieldPredictionRequired);
  bool _showSubmitButton = controller.selectedState != null &&
      controller.selectedDistrict != null &&
      (controller.areCropsAvailable
          ? controller.yieldPredictionRequired
              ? (controller.selectedCrop != null &&
                  controller.selectedSeason != null)
              : true
          : true);

  return WillPopScope(
    onWillPop: () => Future.sync(controller.onWillPopScopePage1),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (!_showStateList || !_showDistrictList)
              CircularProgressIndicator(),
            if (_showStateList)
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: AppTheme.normalBlackBorderDecoration,
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, bottom: 10),
                        child: Text(
                          'State: ',
                          style:
                              AppTheme.headingBoldText.copyWith(fontSize: 17),
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
                    if (_showDistrictList) SizedBox(height: 20),
                    if (_showDistrictList)
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
            if (controller.cropListLoading) CircularProgressIndicator(),
            if (_showRadioButton)
              RadioListTile(
                toggleable: true,
                title: Text('Predict Yield?'),
                value: true,
                groupValue: controller.yieldPredictionRequired,
                onChanged: (_) {
                  controller.toggleRadioButton();
                },
              ),
            if (_showCropsList) CropsColumnWidget(controller: controller),
            if (controller.seasonListLoading) CircularProgressIndicator(),
            if (_showSeasonsList) SeasonsColumnWidget(controller: controller),
            if (_showRangeWidget) RangeColumnWidget(controller: controller),
            if (_showSubmitButton) SizedBox(height: 40),
            if (_showSubmitButton)
              CustomButton(
                isActive: true,
                isOverlayRequired: false,
                onPressed: () {
                  controller.proceedToPrediction();
                },
                title: 'Submit',
              ),
          ],
        ),
      ),
    ),
  );
}
