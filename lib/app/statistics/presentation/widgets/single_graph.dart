import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../statistics_view.dart';

Widget singleGraph({
  @required String xAxisName,
  @required double visibleMinimum,
  @required int maximumLabels,
  @required String yAxisName,
  @required String yAxisLabel,
  @required List<ChartData> dataSource,
}) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(
      name: yAxisName,
      title: AxisTitle(text: yAxisName),
      visibleMaximum: visibleMinimum,
      labelRotation: -90,
      maximumLabels: maximumLabels,
    ),
    primaryYAxis: NumericAxis(
      name: yAxisName,
      title: AxisTitle(
        text: yAxisLabel,
      ),
    ),
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
      ColumnSeries<ChartData, String>(
        name: yAxisName,
        dataSource: dataSource,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        isTrackVisible: true,
        pointColorMapper: (ChartData data, _) => data.color,
        trackColor: Color(0xffE5E5E5),
        borderRadius: BorderRadius.circular(10),
      )
    ],
  );
}
