import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../prediction_controller.dart';

Widget yieldPredictionContainer({
  @required PredictionPageController controller,
}) {
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'YIELD PREDICTION',
            style: AppTheme.headingBoldText.copyWith(fontSize: 17),
          ),
        ),
      ),
      Container(
        decoration: AppTheme.normalBlackBorderDecoration,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: 'State: ',
                  style: AppTheme.bodyBoldText
                      .copyWith(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: controller.selectedStateName(),
                      style: AppTheme.headingRegularText
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: 'District: ',
                  style: AppTheme.bodyBoldText
                      .copyWith(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: controller.selectedDistrictName(),
                      style: AppTheme.headingRegularText
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: 'Area of land: ',
                  style: AppTheme.bodyBoldText
                      .copyWith(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: controller.areaText.text.length == 0
                          ? '${controller.userEntity.area} acres'
                          : '${controller.areaText.text} acres',
                      style: AppTheme.headingRegularText
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: 'Crop: ',
                  style: AppTheme.bodyBoldText
                      .copyWith(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text:
                          '${controller.getCropNameFromCropId(controller.selectedCrop)}',
                      style: AppTheme.headingRegularText
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: 'Season: ',
                  style: AppTheme.bodyBoldText
                      .copyWith(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: '${controller.selectedSeason}',
                      style: AppTheme.headingRegularText
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: 'Yield: ',
                  style: AppTheme.bodyBoldText
                      .copyWith(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text:
                          '${controller.calculatePersonalisedYield()} quintals',
                      style: AppTheme.headingRegularText
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}
