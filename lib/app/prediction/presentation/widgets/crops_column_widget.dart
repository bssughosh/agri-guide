import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../prediction_controller.dart';

class CropsColumnWidget extends StatelessWidget {
  final PredictionPageController controller;

  const CropsColumnWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 10),
              child: Text(
                'Crop: ',
                style: AppTheme.headingBoldText.copyWith(fontSize: 17),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            child: CustomDropdown(
              hintText: 'Select Crop',
              itemsList: controller.cropItems(),
              selectedItem: controller.selectedCrop,
              onChanged: (String newValue) {
                controller.selectedCrop = newValue;
                controller.selectedCropChange();
              },
            ),
          ),
        ],
      ),
    );
  }
}
