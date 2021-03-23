import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_multi_select_form.dart';
import '../prediction_controller.dart';

class ParamsColumnWidget extends StatelessWidget {
  final PredictionPageController controller;

  const ParamsColumnWidget({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 10),
              child: Text(
                'Select Parameters: ',
                style: AppTheme.headingBoldText.copyWith(fontSize: 17),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            child: CustomMultiselectForm(
              selectedItemList: controller.selectedParams,
              title: 'Select Params',
              dataSource: controller.paramsList,
              displayKey: 'name',
              valueKey: 'id',
              onSavedFunction: controller.updateParamsList,
            ),
          ),
        ],
      ),
    );
  }
}
