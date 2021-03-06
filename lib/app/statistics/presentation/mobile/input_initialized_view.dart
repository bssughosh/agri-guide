import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../statistics_controller.dart';
import '../widgets/location_selection_bar.dart';
import '../widgets/location_selection_card.dart';

Widget buildStatisticsInputInitializedViewMobile({
  @required BuildContext context,
  @required StatisticsPageController controller,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: WillPopScope(
      onWillPop: () => Future.sync(controller.onWillPopScopePage1),
      child: Center(
        child: Container(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
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
                        LocationSelectionBar(
                          controller: controller,
                          selectionListType: SelectionListType.STATE,
                          isWeb: false,
                        ),
                        if (controller.selectedState != '')
                          if (controller.districtListLoading)
                            CircularProgressIndicator(),
                        if (controller.selectedState != '')
                          if (!controller.districtListLoading)
                            LocationSelectionBar(
                              controller: controller,
                              selectionListType: SelectionListType.DISTRICT,
                              isWeb: false,
                            ),
                        SizedBox(
                          height: 20,
                        ),
                        if (controller.selectedState != '' &&
                            controller.selectedDistrict != '')
                          Center(
                            child: TextButton(
                              child: Text(
                                'Submit',
                                style: AppTheme.navigationTabSelectedTextStyle,
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppTheme.navigationSelectedColor),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    AppTheme.secondaryColor),
                              ),
                              onPressed: () {
                                controller.proceedToStatisticsDisplay();
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
                    isWeb: false,
                  ),
                ),
              if (controller.isDistrictFilterClicked)
                Center(
                  child: LocationSelectionCard(
                    controller: controller,
                    selectionListType: SelectionListType.DISTRICT,
                    isWeb: false,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
