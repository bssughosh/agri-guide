import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_multi_select_form.dart';
import '../downloads_controller.dart';

class LocationCard extends StatelessWidget {
  final DownloadsPageController controller;
  final bool showDistrictList;

  const LocationCard({
    @required this.controller,
    @required this.showDistrictList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(5.0),
      decoration: AppTheme.normalBlackBorderDecoration.copyWith(boxShadow: [
        BoxShadow(
          color: Colors.black54,
          offset: const Offset(
            2.0,
            2.0,
          ),
          blurRadius: 5.0,
        ),
        BoxShadow(
          color: Colors.white,
          offset: const Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'State: ',
            style: AppTheme.headingBoldText.copyWith(fontSize: 17),
          ),
          SizedBox(height: 10),
          Container(
            child: CustomMultiselectForm(
              selectedItemList: controller.selectedStates,
              title: 'Select States',
              dataSource: controller.stateList,
              displayKey: 'name',
              valueKey: 'id',
              onSavedFunction: controller.updateStateList,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          if (showDistrictList)
            Text(
              'District: ',
              style: AppTheme.headingBoldText.copyWith(fontSize: 17),
            ),
          if (showDistrictList) SizedBox(height: 10),
          if (showDistrictList)
            Container(
              child: CustomMultiselectForm(
                selectedItemList: controller.selectedDistricts,
                title: 'Select Districts',
                dataSource: controller.districtList,
                displayKey: 'name',
                valueKey: 'id',
                onSavedFunction: controller.updateDistrictList,
              ),
            ),
          if (showDistrictList) SizedBox(height: 10),
        ],
      ),
    );
  }
}
