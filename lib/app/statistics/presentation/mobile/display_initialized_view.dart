import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../statistics_controller.dart';
import '../statistics_view.dart';

Widget buildStatisticsDisplayInitializedViewMobile({
  @required StatisticsPageController controller,
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
                  child: Column(
                    children: [
                      Text(
                        'Select first comparison parameter',
                        style: AppTheme.headingBoldText,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      DropdownButton(
                        hint: Text('Please choose a parameter'),
                        value: controller.selectedFilter1,
                        onChanged: (newValue) {
                          controller.handleFilter1Changed(newValue);
                        },
                        items: controller.filter1.map((f1) {
                          return DropdownMenuItem(
                            child: new Text(describeEnum(f1)),
                            value: f1,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Select second comparison parameter',
                        style: AppTheme.headingBoldText,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      DropdownButton(
                        hint: Text('Please choose a parameter'),
                        value: controller.selectedFilter2,
                        onChanged: (newValue) {
                          controller.handleFilter2Changed(newValue);
                        },
                        items: controller.filter2.map((f2) {
                          return DropdownMenuItem(
                            child: new Text(describeEnum(f2)),
                            value: f2,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    name: 'Year',
                    title: AxisTitle(text: 'Year'),
                    visibleMaximum: 10,
                    labelRotation: -90,
                    maximumLabels: 15,
                  ),
                  primaryYAxis: NumericAxis(
                    name: controller.areElementsToBeSwapped
                        ? describeEnum(controller.selectedFilter2)
                        : describeEnum(controller.selectedFilter1),
                    title: AxisTitle(
                      text: controller.areElementsToBeSwapped
                          ? controller
                              .getAxisLabelName(controller.selectedFilter2)
                          : controller
                              .getAxisLabelName(controller.selectedFilter1),
                    ),
                  ),
                  axes: <ChartAxis>[
                    NumericAxis(
                      name: controller.areElementsToBeSwapped
                          ? describeEnum(controller.selectedFilter1)
                          : describeEnum(controller.selectedFilter2),
                      opposedPosition: true,
                      title: AxisTitle(
                        text: controller.areElementsToBeSwapped
                            ? controller
                                .getAxisLabelName(controller.selectedFilter1)
                            : controller
                                .getAxisLabelName(controller.selectedFilter2),
                      ),
                    ),
                  ],
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePanning: true,
                    enablePinching: true,
                  ),
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    tooltipAlignment: ChartAlignment.near,
                    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                    tooltipSettings: InteractiveTooltip(
                      enable: true,
                      format: 'series.name: point.y',
                    ),
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    borderColor: Colors.black26,
                    borderWidth: 1,
                  ),
                  title: ChartTitle(text: 'Statistics'),
                  series: <CartesianSeries>[
                    !controller.areElementsToBeSwapped
                        ? ColumnSeries<ChartData, String>(
                            name: describeEnum(controller.selectedFilter1),
                            dataSource: controller.selectedFilter1 ==
                                    StatisticsFilters.Rainfall
                                ? controller.rainfallChartData
                                : controller.selectedFilter1 ==
                                        StatisticsFilters.Temperature
                                    ? controller.temperatureChartData
                                    : controller.humidityChartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            isTrackVisible: true,
                            pointColorMapper: (ChartData data, _) => data.color,
                            trackColor: Color(0xffE5E5E5),
                            borderRadius: BorderRadius.circular(10),
                          )
                        : LineSeries<ChartData, String>(
                            name: describeEnum(controller.selectedFilter2),
                            markerSettings: MarkerSettings(isVisible: true),
                            dataSource: controller.selectedFilter2 ==
                                    StatisticsFilters.Rainfall
                                ? controller.rainfallChartData
                                : controller.selectedFilter2 ==
                                        StatisticsFilters.Temperature
                                    ? controller.temperatureChartData
                                    : controller.humidityChartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            color: Colors.black,
                          ),
                    !controller.areElementsToBeSwapped
                        ? LineSeries<ChartData, String>(
                            name: describeEnum(controller.selectedFilter2),
                            markerSettings: MarkerSettings(isVisible: true),
                            dataSource: controller.selectedFilter2 ==
                                    StatisticsFilters.Rainfall
                                ? controller.rainfallChartData
                                : controller.selectedFilter2 ==
                                        StatisticsFilters.Temperature
                                    ? controller.temperatureChartData
                                    : controller.humidityChartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            color: Colors.black,
                            yAxisName: describeEnum(controller.selectedFilter2),
                            xAxisName: 'Year',
                          )
                        : ColumnSeries<ChartData, String>(
                            name: describeEnum(controller.selectedFilter1),
                            dataSource: controller.selectedFilter1 ==
                                    StatisticsFilters.Rainfall
                                ? controller.rainfallChartData
                                : controller.selectedFilter1 ==
                                        StatisticsFilters.Temperature
                                    ? controller.temperatureChartData
                                    : controller.humidityChartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            isTrackVisible: true,
                            pointColorMapper: (ChartData data, _) => data.color,
                            trackColor: Color(0xffE5E5E5),
                            borderRadius: BorderRadius.circular(10),
                            yAxisName: describeEnum(controller.selectedFilter1),
                            xAxisName: 'Year',
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
