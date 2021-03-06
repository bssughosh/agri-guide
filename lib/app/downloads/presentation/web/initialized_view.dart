import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../downloads_controller.dart';
import '../widgets/download_params_selection_bar.dart';
import '../widgets/download_params_selection_card.dart';
import '../widgets/location_selection_bar.dart';
import '../widgets/location_selection_card.dart';
import '../widgets/range_widget.dart';

Widget buildDownloadsInitializedViewWeb({
  @required BuildContext context,
  @required DownloadsPageController controller,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: WillPopScope(
      onWillPop: () => Future.sync(controller.onWillPopScope),
      child: Container(
        child: Stack(
          children: [
            Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      LocationSelectionBar(
                        controller: controller,
                        selectionListType: SelectionListType.STATE,
                        isWeb: true,
                      ),
                      if (controller.selectedStates.length == 1 &&
                          controller.districtList.length > 0)
                        LocationSelectionBar(
                          controller: controller,
                          selectionListType: SelectionListType.DISTRICT,
                          isWeb: true,
                        ),
                      if ((controller.selectedStates.length == 1 &&
                              controller.selectedDistricts.length > 0) ||
                          (controller.selectedStates.length > 1))
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.fromLTRB(20, 5, 25, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Range of Data',
                                style: AppTheme.bodyBoldText,
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: RangeWidget(
                                      controller: controller,
                                      isFrom: true,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: RangeWidget(
                                      controller: controller,
                                      isFrom: false,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      if ((controller.selectedStates.length == 1 &&
                              controller.selectedDistricts.length > 0) ||
                          (controller.selectedStates.length > 1))
                        DownloadParamsSelectionBar(
                          controller: controller,
                          isWeb: true,
                        ),
                      if (((controller.selectedStates.length == 1 &&
                                  controller.selectedDistricts.length > 0) ||
                              (controller.selectedStates.length > 1)) &&
                          controller.selectedParams.length > 0)
                        TextButton(
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
                            controller.downloadFiles();
                          },
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
                  isWeb: true,
                ),
              ),
            if (controller.isDistrictFilterClicked)
              Center(
                child: LocationSelectionCard(
                  controller: controller,
                  selectionListType: SelectionListType.DISTRICT,
                  isWeb: true,
                ),
              ),
            if (controller.isParamsFilterClicked)
              Center(
                child: DownloadParamsSelectionCard(
                  controller: controller,
                  isWeb: true,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
