import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../../../../core/widgets/chip.dart';
import '../../../../core/widgets/custom_button.dart';
import '../statistics_controller.dart';
import '../widgets/double_graph.dart';
import '../widgets/filter_tab.dart';
import '../widgets/single_graph.dart';

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
                SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: AppTheme.normalBlackBorderDecoration,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10),
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
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: chip(
                            label: controller.selectedStateName(),
                            color: AppTheme.chipBackground,
                            textColor: AppTheme.secondaryColor,
                            elevation: 0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10),
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
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: chip(
                            label: controller.selectedDistrictName(),
                            color: AppTheme.chipBackground,
                            textColor: AppTheme.secondaryColor,
                            elevation: 0,
                          ),
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
                    width: MediaQuery.of(context).size.width * 0.45,
                  ),
                if (controller.selectedFilters.length == 1)
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        height: 280,
                        child: singleGraph(
                          xAxisName: 'Year',
                          visibleMinimum: 10,
                          maximumLabels: 20,
                          yAxisName:
                              describeEnum(controller.selectedFilters[0]),
                          yAxisLabel: controller
                              .getAxisLabelName(controller.selectedFilters[0]),
                          dataSource: controller.getPrimaryDatastore(),
                          interval: controller.selectedFilters[0] ==
                                  StatisticsFilters.Temperature
                              ? 1
                              : controller.selectedFilters[0] ==
                                      StatisticsFilters.Humidity
                                  ? 2
                                  : controller.selectedFilters[0] ==
                                          StatisticsFilters.Rainfall
                                      ? 128
                                      : 1,
                          desiredIntervals: controller.selectedFilters[0] ==
                                  StatisticsFilters.Temperature
                              ? 1
                              : controller.selectedFilters[0] ==
                                      StatisticsFilters.Humidity
                                  ? 2
                                  : controller.selectedFilters[0] ==
                                          StatisticsFilters.Rainfall
                                      ? 128
                                      : 1,
                        ),
                      ),
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black45,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              isActive: true,
                              isOverlayRequired: false,
                              onPressed: () {
                                controller.navigateToViewGraph(controller);
                              },
                              title: 'View Graph',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (controller.selectedFilters.length == 2)
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        height: 280,
                        child: doubleGraph(
                          xAxisName: 'Year',
                          visibleMinimum: 10,
                          maximumLabels: 15,
                          primaryYAxisName:
                              describeEnum(controller.selectedFilters1),
                          primaryYAxisLabel: controller
                              .getAxisLabelName(controller.selectedFilters1),
                          secondaryYAxisName:
                              describeEnum(controller.selectedFilters2),
                          secondaryYAxisLabel: controller
                              .getAxisLabelName(controller.selectedFilters2),
                          primaryDataSource: controller.getPrimaryDatastore(),
                          secondaryDataSource:
                              controller.getSecondaryDatastore(),
                          primaryInterval: controller.selectedFilters1 ==
                                  StatisticsFilters.Temperature
                              ? 1
                              : controller.selectedFilters1 ==
                                      StatisticsFilters.Humidity
                                  ? 2
                                  : controller.selectedFilters1 ==
                                          StatisticsFilters.Rainfall
                                      ? 128
                                      : 1,
                          primaryDesiredIntervals:
                              controller.selectedFilters1 ==
                                      StatisticsFilters.Temperature
                                  ? 1
                                  : controller.selectedFilters1 ==
                                          StatisticsFilters.Humidity
                                      ? 2
                                      : controller.selectedFilters1 ==
                                              StatisticsFilters.Rainfall
                                          ? 128
                                          : 1,
                          secondaryInterval: controller.selectedFilters2 ==
                                  StatisticsFilters.Temperature
                              ? 1
                              : controller.selectedFilters2 ==
                                      StatisticsFilters.Humidity
                                  ? 2
                                  : controller.selectedFilters2 ==
                                          StatisticsFilters.Rainfall
                                      ? 128
                                      : 1,
                          secondaryDesiredIntervals:
                              controller.selectedFilters2 ==
                                      StatisticsFilters.Temperature
                                  ? 1
                                  : controller.selectedFilters2 ==
                                          StatisticsFilters.Humidity
                                      ? 2
                                      : controller.selectedFilters2 ==
                                              StatisticsFilters.Rainfall
                                          ? 128
                                          : 1,
                        ),
                      ),
                      Container(
                        height: 280,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black45,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              isActive: true,
                              isOverlayRequired: false,
                              onPressed: () {
                                controller.navigateToViewGraph(controller);
                              },
                              title: 'View Graph',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      filterTab(
                        onPressed: () {
                          controller
                              .onFilterClicked(StatisticsFilters.Temperature);
                        },
                        isSelected: controller.selectedFilters
                            .contains(StatisticsFilters.Temperature),
                        text: describeEnum(StatisticsFilters.Temperature),
                      ),
                      filterTab(
                        onPressed: () {
                          controller
                              .onFilterClicked(StatisticsFilters.Humidity);
                        },
                        isSelected: controller.selectedFilters
                            .contains(StatisticsFilters.Humidity),
                        text: describeEnum(StatisticsFilters.Humidity),
                      ),
                      filterTab(
                        onPressed: () {
                          controller
                              .onFilterClicked(StatisticsFilters.Rainfall);
                        },
                        isSelected: controller.selectedFilters
                            .contains(StatisticsFilters.Rainfall),
                        text: describeEnum(StatisticsFilters.Rainfall),
                      ),
                      if (controller.areCropsAvailable)
                        filterTab(
                          onPressed: () {
                            controller.yieldClicked(context);
                          },
                          isSelected: controller.selectedFilters
                              .contains(StatisticsFilters.Yield),
                          text: describeEnum(StatisticsFilters.Yield),
                        ),
                    ],
                  ),
                ),
                if (controller.yieldStatisticsEntity != null)
                  CustomButton(
                    isActive: true,
                    isOverlayRequired: false,
                    onPressed: () {
                      controller.changeCrop(context);
                    },
                    title: 'Change Crop',
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
