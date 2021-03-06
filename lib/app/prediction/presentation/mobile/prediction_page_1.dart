import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../prediction_controller.dart';
import '../widgets/location_selection_bar.dart';
import '../widgets/location_selection_card.dart';
import '../widgets/prediction_range_mobile_widget.dart';
import '../widgets/prediction_range_widget.dart';
import '../widgets/season_and_crop_mobile_widget.dart';
import '../widgets/season_and_crop_widget.dart';

Widget predictionPage1({
  @required bool isWeb,
  @required PredictionPageController controller,
  @required BuildContext context,
}) {
  if (!controller.stateListInitialized) controller.fetchStateList();
  return Container(
    child: Stack(
      children: [
        Center(
          child: Container(
            width: isWeb
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width,
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
                  if (controller.areCropsAvailable &&
                      (controller.seasonListLoading ||
                          controller.cropListLoading))
                    CircularProgressIndicator(),
                  if (controller.areCropsAvailable &&
                      (!controller.seasonListLoading &&
                          !controller.cropListLoading))
                    isWeb
                        ? SeasonAndCropWidget(controller: controller)
                        : SeasonAndCropMobileWidget(controller: controller),
                  if (controller.selectedState != '' &&
                      controller.selectedDistrict != '' &&
                      (controller.areCropsAvailable
                          ? (controller.selectedCrop != null &&
                              controller.selectedSeason != null)
                          : true))
                    Center(
                      child: isWeb
                          ? PredictionRangeWidget(
                              controller: controller,
                            )
                          : PredictionRangeMobileWidget(
                              controller: controller,
                            ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (controller.selectedState != '' &&
                      controller.selectedDistrict != '' &&
                      (controller.areCropsAvailable
                          ? (controller.selectedCrop != null &&
                              controller.selectedSeason != null)
                          : true))
                    Center(
                      child: TextButton(
                        child: Text(
                          'Submit',
                          style: AppTheme.navigationTabSelectedTextStyle,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppTheme.navigationSelectedColor),
                          overlayColor: MaterialStateProperty.all<Color>(
                              AppTheme.secondaryColor),
                        ),
                        onPressed: () {
                          controller.proceedToPrediction(1);
                        },
                      ),
                    )
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
