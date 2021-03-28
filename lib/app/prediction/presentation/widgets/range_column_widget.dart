import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../prediction_controller.dart';
import 'range_widget.dart';

class RangeColumnWidget extends StatelessWidget {
  final PredictionPageController controller;

  const RangeColumnWidget({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 10),
              child: Text(
                'Select Range of months: ',
                style: AppTheme.headingBoldText.copyWith(fontSize: 17),
              ),
            ),
          ),
          Container(
            decoration: AppTheme.normalGreenBorderDecoration,
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RangeWidget(
                  title: 'From',
                  hintText: 'From',
                  itemsList: controller.monthItems(),
                  selectedItem: controller.startMonth,
                  onChanged: controller.fromMonthUpdated,
                ),
                RangeWidget(
                  title: 'To',
                  hintText: 'To',
                  itemsList: controller.monthItems(),
                  selectedItem: controller.endMonth,
                  onChanged: controller.toMonthUpdated,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
