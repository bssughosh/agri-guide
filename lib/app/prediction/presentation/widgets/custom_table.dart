import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../prediction_controller.dart';

class CustomTable extends StatelessWidget {
  final PredictionPageController controller;
  final TableType tableType;
  final bool isWeb;

  const CustomTable({
    @required this.controller,
    @required this.tableType,
    @required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWeb
          ? MediaQuery.of(context).size.width / 3
          : MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              '${(describeEnum(tableType))} PREDICTION',
              style: AppTheme.headingBoldText,
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: AppTheme.customTableHeadingCellDecoration,
                  children: [
                    TableCell(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'MONTH',
                            style: AppTheme.customTableHeadingTextStyle,
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: tableType == TableType.TEMPERATURE
                              ? Text(
                                  'PREDICTED ${(describeEnum(tableType))} (\u2103)',
                                  style: AppTheme.customTableHeadingTextStyle,
                                  textAlign: TextAlign.center,
                                )
                              : tableType == TableType.HUMIDITY
                                  ? Text(
                                      'PREDICTED ${(describeEnum(tableType))} (%)',
                                      style:
                                          AppTheme.customTableHeadingTextStyle,
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      'PREDICTED ${(describeEnum(tableType))} (mm)',
                                      style:
                                          AppTheme.customTableHeadingTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < controller.monthsToDisplay.length; i++)
                  TableRow(
                    decoration: AppTheme.customTableRowCellDecoration,
                    children: [
                      TableCell(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              controller.monthsToDisplay[i],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: tableType == TableType.TEMPERATURE
                                ? Text(
                                    controller.temperature[i],
                                    textAlign: TextAlign.center,
                                  )
                                : tableType == TableType.HUMIDITY
                                    ? Text(
                                        controller.humidity[i],
                                        textAlign: TextAlign.center,
                                      )
                                    : Text(
                                        controller.rainfall[i],
                                        textAlign: TextAlign.center,
                                      ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
