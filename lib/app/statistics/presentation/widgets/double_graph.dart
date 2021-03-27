import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../statistics_view.dart';

Widget doubleGraph({
  @required String xAxisName,
  @required double visibleMinimum,
  @required int maximumLabels,
  @required String primaryYAxisName,
  @required String primaryYAxisLabel,
  @required String secondaryYAxisName,
  @required String secondaryYAxisLabel,
  @required List<ChartData> primaryDataSource,
  @required List<ChartData> secondaryDataSource,
  @required double primaryInterval,
  @required int primaryDesiredIntervals,
  @required double secondaryInterval,
  @required int secondaryDesiredIntervals,
}) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(
      name: xAxisName,
      title: AxisTitle(text: xAxisName),
      visibleMaximum: visibleMinimum,
      labelRotation: -90,
      maximumLabels: maximumLabels,
    ),
    primaryYAxis: NumericAxis(
      name: primaryYAxisName,
      title: AxisTitle(text: primaryYAxisLabel),
      interval: primaryInterval,
      rangePadding: ChartRangePadding.additional,
      desiredIntervals: primaryDesiredIntervals,
      decimalPlaces: 0,
    ),
    axes: <ChartAxis>[
      NumericAxis(
        name: secondaryYAxisName,
        opposedPosition: true,
        title: AxisTitle(text: secondaryYAxisLabel),
        interval: secondaryInterval,
        rangePadding: ChartRangePadding.additional,
        desiredIntervals: secondaryDesiredIntervals,
        decimalPlaces: 0,
      ),
    ],
    zoomPanBehavior: ZoomPanBehavior(
      enablePanning: true,
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
      toggleSeriesVisibility: false,
    ),
    title: ChartTitle(text: 'Statistics'),
    series: <CartesianSeries>[
      ColumnSeries<ChartData, String>(
        name: primaryYAxisName,
        dataSource: primaryDataSource,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        isTrackVisible: true,
        pointColorMapper: (ChartData data, _) => data.color,
        trackColor: Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(10),
      ),
      LineSeries<ChartData, String>(
        name: secondaryYAxisName,
        markerSettings: MarkerSettings(isVisible: true),
        dataSource: secondaryDataSource,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        color: Colors.black,
        yAxisName: secondaryYAxisName,
        xAxisName: 'Year',
      ),
    ],
  );
}
