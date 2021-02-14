import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../prediction_controller.dart';

class PredictionRangeMobileWidget extends StatelessWidget {
  final PredictionPageController controller;

  const PredictionRangeMobileWidget({
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Text(
              'Start Month',
              style: AppTheme.headingBoldText,
            ),
            SizedBox(
              height: 5,
            ),
            DropdownButton<String>(
              hint: Text('Please choose start month'),
              value: controller.startMonth,
              onChanged: (newValue) {
                controller.handleStartMonthDropDownChange(newValue);
              },
              items: controller.months.map((month) {
                return DropdownMenuItem(
                  child: new Text(month),
                  value: month,
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text(
              'End Month',
              style: AppTheme.headingBoldText,
            ),
            SizedBox(
              height: 5,
            ),
            DropdownButton<String>(
              hint: Text('Please choose end month'),
              value: controller.endMonth,
              onChanged: (newValue) {
                controller.handleEndMonthDropDownChange(newValue);
              },
              items: controller.months.map((month) {
                return DropdownMenuItem(
                  child: new Text(month),
                  value: month,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
