import 'package:agri_guide/app/downloads/presentation/widgets/range_widget.dart';
import 'package:agri_guide/core/app_theme.dart';
import 'package:agri_guide/core/widgets/custom_button.dart';
import 'package:agri_guide/core/widgets/custom_checkbox_tile.dart';
import 'package:agri_guide/core/widgets/custom_multi_select_form.dart';
import 'package:flutter/material.dart';

import '../downloads_controller.dart';

Widget buildDownloadsInitializedViewWeb({
  @required BuildContext context,
  @required DownloadsPageController controller,
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

  return Container(
    width: MediaQuery.of(context).size.width,
    child: controller.isDownloading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : WillPopScope(
            onWillPop: () => Future.sync(controller.onWillPopScope),
            child: Container(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 25, bottom: 10),
                            child: Text(
                              'States: ',
                              style: AppTheme.headingBoldText
                                  .copyWith(fontSize: 17),
                            ),
                          ),
                        ),
                        Container(
                          child: CustomMultiselectForm(
                            selectedItemList: controller.selectedStates,
                            title: 'Select States',
                            dataSource: controller.stateList,
                            displayKey: 'name',
                            valueKey: 'id',
                            onSavedFunction: controller.updateStateList,
                          ),
                        ),
                        if (_showDistrictList) SizedBox(height: 20),
                        if (_showDistrictList)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, bottom: 10),
                              child: Text(
                                'Districts: ',
                                style: AppTheme.headingBoldText
                                    .copyWith(fontSize: 17),
                              ),
                            ),
                          ),
                        if (_showDistrictList)
                          Container(
                            child: CustomMultiselectForm(
                              selectedItemList: controller.selectedDistricts,
                              title: 'Select Districts',
                              dataSource: controller.districtList,
                              displayKey: 'name',
                              valueKey: 'id',
                              onSavedFunction: controller.updateDistrictList,
                            ),
                          ),
                        if (_showRange) SizedBox(height: 20),
                        if (_showRange)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, bottom: 10),
                              child: Text(
                                'Year Range: ',
                                style: AppTheme.headingBoldText
                                    .copyWith(fontSize: 17),
                              ),
                            ),
                          ),
                        if (_showRange)
                          Container(
                            decoration: AppTheme.normalGreenBorderDecoration,
                            padding: EdgeInsets.all(10),
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
                                  itemsList: controller.yearItems(),
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
                              padding:
                                  const EdgeInsets.only(left: 25, bottom: 10),
                              child: Text(
                                'Select Parameters: ',
                                style: AppTheme.headingBoldText
                                    .copyWith(fontSize: 17),
                              ),
                            ),
                          ),
                        if (_showParams)
                          Container(
                            child: Column(
                              children: [
                                for (Map<String, String> item
                                    in controller.paramsList)
                                  Container(
                                    decoration:
                                        AppTheme.normalGreenBorderDecoration,
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
                                          controller.selectedParams
                                              .add(item['id']);
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
                              controller.downloadFilesMobile();
                            },
                            isOverlayRequired: false,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
  );
}
