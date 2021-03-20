import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../prediction_controller.dart';
import '../widgets/range_widget.dart';

Widget buildPredictionInputInitializedViewMobile({
  @required PredictionPageController controller,
  @required BuildContext context,
}) {
  if (!controller.stateListInitialized) controller.fetchStateList();

  bool _showLoadingIndicator = controller.stateListLoading ||
      controller.districtListLoading ||
      (controller.areCropsAvailable &&
          (controller.seasonListLoading || controller.cropListLoading));
  bool _showStateList = !controller.stateListLoading;
  bool _showDistrictList =
      controller.selectedState != null && !controller.districtListLoading;
  bool _showSeasonsList =
      controller.areCropsAvailable && !controller.seasonListLoading;
  bool _showCropsList =
      controller.areCropsAvailable && !controller.cropListLoading;
  bool _showRangeWidget =
      !controller.areCropsAvailable && !controller.seasonListLoading;

  return WillPopScope(
    onWillPop: () => Future.sync(controller.onWillPopScopePage1),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (_showLoadingIndicator) CircularProgressIndicator(),
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
            if (_showRangeWidget)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 10),
                  child: Text(
                    'Select Range of months: ',
                    style: AppTheme.headingBoldText.copyWith(fontSize: 17),
                  ),
                ),
              ),
            if (_showRangeWidget)
              Container(
                decoration: AppTheme.normalGreenBorderDecoration,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RangeWidget(
                      title: 'From',
                      hintText: 'From',
                      itemsList: controller.monthItems(),
                      selectedItem: controller.startMonth,
                      onChanged: controller.fromMonthUpdated,
                    ),
                    RangeWidget(
                      title: 'To',
                      hintText: 'To',
                      itemsList: controller.monthItems(),
                      selectedItem: controller.endMonth,
                      onChanged: controller.toMonthUpdated,
                    ),
                  ],
                ),
              ),
            if (_showSeasonsList) SizedBox(height: 20),
            if (_showSeasonsList)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 10),
                  child: Text(
                    'Season: ',
                    style: AppTheme.headingBoldText.copyWith(fontSize: 17),
                  ),
                ),
              ),
            if (_showSeasonsList) SizedBox(height: 5),
            if (_showSeasonsList)
              Container(
                width: double.infinity,
                child: CustomDropdown(
                  hintText: 'Select Season',
                  itemsList: controller.seasonItems(),
                  selectedItem: controller.selectedSeason,
                  onChanged: (String newValue) {
                    controller.selectedSeason = newValue;
                    controller.selectedSeasonChange();
                  },
                ),
              ),
            if (_showCropsList) SizedBox(height: 20),
            if (_showCropsList)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 10),
                  child: Text(
                    'Crop: ',
                    style: AppTheme.headingBoldText.copyWith(fontSize: 17),
                  ),
                ),
              ),
            if (_showCropsList) SizedBox(height: 5),
            if (_showCropsList)
              Container(
                width: double.infinity,
                child: CustomDropdown(
                  hintText: 'Select Crop',
                  itemsList: controller.cropItems(),
                  selectedItem: controller.selectedCrop,
                  onChanged: (String newValue) {
                    controller.selectedCrop = newValue;
                    controller.selectedCropChange();
                  },
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
