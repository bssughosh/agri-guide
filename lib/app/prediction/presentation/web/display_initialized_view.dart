import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../prediction_controller.dart';
import '../widgets/custom_table.dart';
import '../widgets/yield_prediction_container.dart';

Widget buildPredictionDisplayInitializedViewWeb({
  @required PredictionPageController controller,
  @required BuildContext context,
}) {
  return WillPopScope(
    onWillPop: () => Future.sync(controller.onWillPopScopePage2),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            if (!controller.selectedParams
                .contains(describeEnum(DownloadParams.yield)))
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
                  ],
                ),
              )
            else
              yieldPredictionContainer(controller: controller),
            SizedBox(height: 30),
            if (controller.selectedParams
                .contains(describeEnum(DownloadParams.temp)))
              CustomTable(
                dataSource: controller.temperature,
                tableType: TableType.TEMPERATURE,
                months: controller.monthsToDisplay,
                columnName:
                    controller.getColumnNameForTable(TableType.TEMPERATURE),
              ),
            SizedBox(height: 15),
            if (controller.selectedParams
                .contains(describeEnum(DownloadParams.humidity)))
              CustomTable(
                dataSource: controller.humidity,
                tableType: TableType.HUMIDITY,
                months: controller.monthsToDisplay,
                columnName:
                    controller.getColumnNameForTable(TableType.HUMIDITY),
              ),
            SizedBox(height: 15),
            if (controller.selectedParams
                .contains(describeEnum(DownloadParams.rainfall)))
              CustomTable(
                dataSource: controller.rainfall,
                tableType: TableType.RAINFALL,
                months: controller.monthsToDisplay,
                columnName:
                    controller.getColumnNameForTable(TableType.RAINFALL),
              ),
          ],
        ),
      ),
    ),
  );
}
