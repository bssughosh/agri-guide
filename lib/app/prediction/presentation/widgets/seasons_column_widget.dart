import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../prediction_controller.dart';

class SeasonsColumnWidget extends StatelessWidget {
  final PredictionPageController controller;

  const SeasonsColumnWidget({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 10),
              child: Text(
                'Season: ',
                style: AppTheme.headingBoldText.copyWith(fontSize: 17),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            child: CustomDropdown(
              hintText: 'Select Season',
              itemsList: controller.seasonItems(),
              selectedItem: controller.selectedSeason,
              onChanged: (String newValue) {
                controller.selectedSeason = newValue;
                controller.selectedSeasonChange();
              },
            ),
          ),
        ],
      ),
    );
  }
}
