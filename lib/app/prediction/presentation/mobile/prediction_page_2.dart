import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../prediction_controller.dart';
import '../widgets/custom_table.dart';

Widget predictionPage2({
  @required bool isWeb,
  @required PredictionPageController controller,
  @required BuildContext context,
}) {
  return Container(
    width: isWeb
        ? MediaQuery.of(context).size.width / 3
        : MediaQuery.of(context).size.width,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          if (controller.isPredicting) CircularProgressIndicator(),
          if (!controller.isPredicting && controller.temperature.length > 0)
            CustomTable(
              controller: controller,
              tableType: TableType.TEMPERATURE,
              isWeb: isWeb,
            ),
          SizedBox(height: 15),
          if (!controller.isPredicting && controller.humidity.length > 0)
            CustomTable(
              controller: controller,
              tableType: TableType.HUMIDITY,
              isWeb: isWeb,
            ),
          SizedBox(height: 15),
          if (!controller.isPredicting && controller.rainfall.length > 0)
            CustomTable(
              controller: controller,
              tableType: TableType.RAINFALL,
              isWeb: isWeb,
            ),
          SizedBox(height: 15),
          if (!controller.isPredicting && controller.predictedYield != -1)
            Center(
              child: Container(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'YIELD PREDICTION',
                        style: AppTheme.headingBoldText,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'SEASON: ' + controller.selectedSeason,
                        style: AppTheme.headingRegularText,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'CROP: ' +
                            controller
                                .getCropNameFromCropId(controller.selectedCrop),
                        style: AppTheme.headingRegularText,
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'PREDICTED YIELD: ' +
                            controller.calculatePersonalisedYield() +
                            ' quintals',
                        style: AppTheme.headingRegularText,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          SizedBox(height: 100),
        ],
      ),
    ),
  );
}
