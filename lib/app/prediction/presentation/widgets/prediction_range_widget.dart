import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../prediction_controller.dart';

class PredictionRangeWidget extends StatelessWidget {
  final PredictionPageController controller;

  const PredictionRangeWidget({
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
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
              ],
            ),
          ),
          SizedBox(width: 15),
          Container(
            child: Column(
              children: [
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
        ],
      ),
    );
  }
}
