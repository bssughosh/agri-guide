import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_checkbox_tile.dart';
import '../downloads_controller.dart';
import '../widgets/location_card.dart';
import '../widgets/range_widget.dart';

Widget buildDownloadsInitializedViewMobile({
  required BuildContext context,
  required DownloadsPageController controller,
}) {
  bool _showDistrictList = controller.selectedStates.length == 1 &&
      controller.districtList.length > 0;
  bool _showRange = (controller.selectedStates.length == 1 &&
          controller.selectedDistricts.length > 0) ||
      (controller.selectedStates.length > 1);
  bool _showParams = ((controller.selectedStates.length == 1 &&
              controller.selectedDistricts.length > 0) ||
          (controller.selectedStates.length > 1)) &&
      (controller.toText != null && controller.fromText != null);
  bool _showSubmitButton = ((controller.selectedStates.length == 1 &&
              controller.selectedDistricts.length > 0) ||
          (controller.selectedStates.length > 1)) &&
      (controller.toText != null && controller.fromText != null);
  bool _showDownloads = controller.downloadedFilesToBeDisplayed.length != 0;

  return Container(
    width: MediaQuery.of(context).size.width,
    child: WillPopScope(
      onWillPop: () => Future.sync(controller.onWillPopScope),
      child: Container(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  LocationCard(
                    controller: controller,
                    showDistrictList: _showDistrictList,
                  ),
                  if (_showRange) SizedBox(height: 20),
                  if (_showRange)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 10),
                        child: Text(
                          'Year Range: ',
                          style:
                              AppTheme.headingBoldText.copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                  if (_showRange)
                    Container(
                      decoration: AppTheme.normalGreenBorderDecoration,
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RangeWidget(
                            title: 'From',
                            hintText: 'From',
                            itemsList: controller.yearItems(),
                            selectedItem: controller.fromText,
                            onChanged: controller.fromYearUpdated,
                          ),
                          RangeWidget(
                            title: 'To',
                            hintText: 'To',
                            itemsList: controller.yearItems().reversed.toList(),
                            selectedItem: controller.toText,
                            onChanged: controller.toYearUpdated,
                          ),
                        ],
                      ),
                    ),
                  if (_showParams) SizedBox(height: 20),
                  if (_showParams)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 10),
                        child: Text(
                          'Select Parameters: ',
                          style:
                              AppTheme.headingBoldText.copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                  if (_showParams)
                    Container(
                      child: Column(
                        children: [
                          for (Map<String, String> item in controller.paramsList
                              as Iterable<Map<String, String>>)
                            Container(
                              decoration: AppTheme.normalGreenBorderDecoration,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(vertical: 0),
                              child: CustomCheckboxTile(
                                isSelected: controller.selectedParams
                                    .contains(item['id']),
                                title: item['name'],
                                onChanged: () {
                                  if (controller.selectedParams
                                      .contains(item['id'])) {
                                    controller.selectedParams
                                        .remove(item['id']);
                                  } else {
                                    controller.selectedParams.add(item['id']);
                                  }
                                  controller.selectedParamsChanged();
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (_showSubmitButton) SizedBox(height: 30),
                  if (_showSubmitButton)
                    CustomButton(
                      title: 'Download',
                      isActive: controller.selectedParams.length > 0,
                      onPressed: () {
                        controller.downloadFilesMobile(context: context);
                      },
                      isOverlayRequired: false,
                    ),
                  if (_showDownloads)
                    SizedBox(height: 50)
                  else
                    SizedBox(height: 100),
                  if (_showDownloads)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, bottom: 10),
                        child: Text(
                          'Previously Downloaded Files: ',
                          style:
                              AppTheme.headingBoldText.copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                  if (_showDownloads)
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: AppTheme.normalBlackBorderDecoration,
                      child: Column(
                        children: [
                          for (int i = 0;
                              i <
                                  controller
                                      .downloadedFilesToBeDisplayed.length;
                              i++)
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${i + 1}: ${controller.downloadedFilesToBeDisplayed[i]}',
                                    style: AppTheme.bodyRegularText,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                                if (i !=
                                    (controller.downloadedFilesToBeDisplayed
                                            .length -
                                        1))
                                  Divider(),
                              ],
                            ),
                        ],
                      ),
                    ),
                  if (_showDownloads) SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
