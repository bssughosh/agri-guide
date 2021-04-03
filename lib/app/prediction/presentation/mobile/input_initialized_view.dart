import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../prediction_controller.dart';
import '../widgets/crops_column_widget.dart';
import '../widgets/params_column_widget.dart';
import '../widgets/range_column_widget.dart';
import '../widgets/seasons_column_widget.dart';

Widget buildPredictionInputInitializedViewMobile({
  @required PredictionPageController controller,
  @required BuildContext context,
}) {
  if (!controller.stateListInitialized) controller.fetchStateList();

  bool _showStateList = controller.stateList.isNotEmpty;
  bool _showDistrictList =
      controller.selectedState != null && controller.districtList.isNotEmpty;
  bool _showCropsList = controller.areCropsAvailable &&
      controller.cropsList.isNotEmpty &&
      controller.selectedDistrict != null &&
      controller.selectedParams.contains(describeEnum(DownloadParams.yield));
  bool _showSeasonsList = controller.areCropsAvailable &&
      controller.seasonsList.isNotEmpty &&
      controller.selectedCrop != null &&
      controller.selectedParams.contains(describeEnum(DownloadParams.yield));
  bool _showParams = controller.selectedDistrict != null;
  bool _showRangeWidget = controller.areCropsAvailable
      ? !controller.selectedParams
              .contains(describeEnum(DownloadParams.yield)) &&
          controller.selectedDistrict != null
      : controller.selectedDistrict != null;
  bool _showSubmitButton = controller.selectedState != null &&
      controller.selectedDistrict != null &&
      (controller.areCropsAvailable
          ? controller.selectedParams
                  .contains(describeEnum(DownloadParams.yield))
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
            SizedBox(height: 30),
            if (_showStateList)
              Container(
                decoration: AppTheme.normalBlackBorderDecoration,
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 10),
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
                          padding: const EdgeInsets.only(left: 5, bottom: 10),
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

                            _showMyDialog(
                                context: context, controller: controller);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            if (_showParams) ParamsColumnWidget(controller: controller),
            if (_showCropsList) CropsColumnWidget(controller: controller),
            if (_showSeasonsList) SeasonsColumnWidget(controller: controller),
            if (_showRangeWidget) RangeColumnWidget(controller: controller),
            if (_showSubmitButton) SizedBox(height: 40),
            if (_showSubmitButton)
              CustomButton(
                isActive: controller.selectedParams.length > 0,
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

Future<void> _showMyDialog({
  @required BuildContext context,
  @required PredictionPageController controller,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Text('Enter Area'),
        content: TextField(
          controller: controller.areaText,
          decoration: InputDecoration(
            fillColor: Colors.white,
            labelText: 'Area',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onChanged: (value) {
            controller.textFieldChanged();
          },
          onSubmitted: (value) {
            if (controller.areaText.text.length > 0) {
              Navigator.of(context).pop();
            } else {
              Fluttertoast.showToast(msg: 'Area cannot be empty');
            }
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Done'),
            onPressed: () {
              if (controller.areaText.text.length > 0) {
                Navigator.of(context).pop();
              } else {
                Fluttertoast.showToast(msg: 'Area cannot be empty');
              }
            },
          ),
        ],
      );
    },
  );
}
