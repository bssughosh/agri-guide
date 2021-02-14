import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../prediction_controller.dart';

class SeasonAndCropMobileWidget extends StatelessWidget {
  final PredictionPageController controller;

  const SeasonAndCropMobileWidget({
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            if (controller.seasonsList.length > 0)
              Container(
                child: Column(
                  children: [
                    Text(
                      'Select Season',
                      style: AppTheme.headingBoldText,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    DropdownButton(
                      hint: Text('Please choose a season'),
                      value: controller.selectedSeason,
                      onChanged: (newValue) {
                        controller.handleSeasonDropDownChange(newValue);
                      },
                      items: controller.seasonsList.map((season) {
                        return DropdownMenuItem(
                          child: new Text(season),
                          value: season,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            SizedBox(width: 15),
            if (controller.cropsList.length > 0)
              Container(
                child: Column(
                  children: [
                    Text(
                      'Select Crop',
                      style: AppTheme.headingBoldText,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    DropdownButton(
                      hint: Text('Please choose a crop'),
                      value: controller.selectedCrop,
                      onChanged: (newValue) {
                        controller.handleCropDropDownChange(newValue);
                      },
                      items: controller.cropsList.map((crop) {
                        return DropdownMenuItem(
                          child: new Text(crop['name']),
                          value: crop['crop_id'],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
