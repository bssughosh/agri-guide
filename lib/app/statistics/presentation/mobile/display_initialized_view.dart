import 'package:agri_guide/core/widgets/chip.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../statistics_controller.dart';
import '../statistics_view.dart';

Widget buildStatisticsDisplayInitializedViewMobile({
  @required StatisticsPageController controller,
  @required BuildContext context,
}) {
  return Container(
    child: WillPopScope(
      onWillPop: () => Future.sync(controller.onWillPopScopePage2),
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: AppTheme.normalBlackBorderDecoration,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, bottom: 10),
                          child: Text(
                            'State: ',
                            style:
                                AppTheme.headingBoldText.copyWith(fontSize: 17),
                          ),
                        ),
                      ),
                      Container(
                        decoration: AppTheme.normalBlackBorderDecoration,
                        margin: EdgeInsets.all(8),
                        child: chip(
                          label: controller.selectedState,
                          color: AppTheme.chipBackground,
                          textColor: AppTheme.secondaryColor,
                          elevation: 0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, bottom: 10),
                          child: Text(
                            'District: ',
                            style:
                                AppTheme.headingBoldText.copyWith(fontSize: 17),
                          ),
                        ),
                      ),
                      Container(
                        decoration: AppTheme.normalBlackBorderDecoration,
                        margin: EdgeInsets.all(8),
                        child: chip(
                          label: controller.selectedDistrict,
                          color: AppTheme.chipBackground,
                          textColor: AppTheme.secondaryColor,
                          elevation: 0,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (controller.selectedFilters.length == 0)
                  Image.asset(
                    'assets/no_filter_selected.png',
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
