import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../prediction_controller.dart';
import '../widgets/custom_table.dart';

Widget buildPredictionDisplayInitializedViewMobile({
  @required PredictionPageController controller,
  @required BuildContext context,
}) {
  return WillPopScope(
    onWillPop: () => Future.sync(controller.onWillPopScopePage2),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (controller.selectedParams
                .contains(describeEnum(DownloadParams.temp)))
              CustomTable(
                controller: controller,
                tableType: TableType.TEMPERATURE,
                isWeb: false,
              ),
            SizedBox(height: 15),
            if (controller.selectedParams
                .contains(describeEnum(DownloadParams.humidity)))
              CustomTable(
                controller: controller,
                tableType: TableType.HUMIDITY,
                isWeb: false,
              ),
            SizedBox(height: 15),
            if (controller.selectedParams
                .contains(describeEnum(DownloadParams.rainfall)))
              CustomTable(
                controller: controller,
                tableType: TableType.RAINFALL,
                isWeb: false,
              ),
            SizedBox(height: 15),
            if (controller.selectedParams
                .contains(describeEnum(DownloadParams.yield)))
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
                              controller.getCropNameFromCropId(
                                controller.selectedCrop,
                              ),
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
          ],
        ),
      ),
    ),
  );
}
