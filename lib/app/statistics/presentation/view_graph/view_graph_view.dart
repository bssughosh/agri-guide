import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../statistics_controller.dart';
import '../widgets/double_graph.dart';
import '../widgets/single_graph.dart';
import 'view_graph_controller.dart';
import 'view_graph_state_machine.dart';

class ViewGraphPage extends View {
  final ViewGraphParams params;

  ViewGraphPage(this.params);

  @override
  State<StatefulWidget> createState() => ViewGraphViewState();
}

class ViewGraphViewState
    extends ResponsiveViewState<ViewGraphPage, ViewGraphPageController> {
  ViewGraphViewState() : super(new ViewGraphPageController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    print('Dispose called');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case ViewGraphPageInitializationState:
        return _buildViewGraphInitializationViewMobile(
          controller: controller,
          statisticsPageController: widget.params.statisticsPageController,
        );
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  @override
  Widget buildTabletView() {
    return buildMobileView();
  }

  @override
  Widget buildDesktopView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case ViewGraphPageInitializationState:
        return _buildViewGraphInitializationViewWeb(
          controller: controller,
          statisticsPageController: widget.params.statisticsPageController,
        );
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  Widget _buildViewGraphInitializationViewMobile({
    @required ViewGraphPageController controller,
    @required StatisticsPageController statisticsPageController,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          describeEnum(
                  widget.params.statisticsPageController.selectedFilters1) +
              (widget.params.statisticsPageController.selectedFilters.length ==
                      2
                  ? ' VS ' +
                      describeEnum(widget
                          .params.statisticsPageController.selectedFilters2)
                  : ''),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: statisticsPageController.selectedFilters.length == 1
              ? singleGraph(
                  xAxisName: 'Year',
                  visibleMinimum: 20,
                  maximumLabels: 20,
                  yAxisName:
                      describeEnum(statisticsPageController.selectedFilters[0]),
                  yAxisLabel: statisticsPageController.getAxisLabelName(
                      statisticsPageController.selectedFilters[0]),
                  dataSource: statisticsPageController.getPrimaryDatastore(),
                  interval: statisticsPageController.selectedFilters[0] ==
                          StatisticsFilters.Temperature
                      ? 1
                      : statisticsPageController.selectedFilters[0] ==
                              StatisticsFilters.Humidity
                          ? 2
                          : statisticsPageController.selectedFilters[0] ==
                                  StatisticsFilters.Rainfall
                              ? 128
                              : 5,
                  desiredIntervals:
                      statisticsPageController.selectedFilters[0] ==
                              StatisticsFilters.Temperature
                          ? 1
                          : statisticsPageController.selectedFilters[0] ==
                                  StatisticsFilters.Humidity
                              ? 2
                              : statisticsPageController.selectedFilters[0] ==
                                      StatisticsFilters.Rainfall
                                  ? 128
                                  : 5,
                )
              : doubleGraph(
                  xAxisName: 'Year',
                  visibleMinimum: 20,
                  maximumLabels: 15,
                  primaryYAxisName:
                      describeEnum(statisticsPageController.selectedFilters[0]),
                  primaryYAxisLabel: statisticsPageController.getAxisLabelName(
                      statisticsPageController.selectedFilters[0]),
                  secondaryYAxisName:
                      describeEnum(statisticsPageController.selectedFilters[1]),
                  secondaryYAxisLabel:
                      statisticsPageController.getAxisLabelName(
                          statisticsPageController.selectedFilters[1]),
                  primaryDataSource:
                      statisticsPageController.getPrimaryDatastore(),
                  secondaryDataSource:
                      statisticsPageController.getSecondaryDatastore(),
                  primaryInterval: statisticsPageController.selectedFilters1 ==
                          StatisticsFilters.Temperature
                      ? 1
                      : statisticsPageController.selectedFilters1 ==
                              StatisticsFilters.Humidity
                          ? 2
                          : statisticsPageController.selectedFilters1 ==
                                  StatisticsFilters.Rainfall
                              ? 128
                              : 5,
                  primaryDesiredIntervals:
                      statisticsPageController.selectedFilters1 ==
                              StatisticsFilters.Temperature
                          ? 1
                          : statisticsPageController.selectedFilters1 ==
                                  StatisticsFilters.Humidity
                              ? 2
                              : statisticsPageController.selectedFilters1 ==
                                      StatisticsFilters.Rainfall
                                  ? 128
                                  : 5,
                  secondaryInterval:
                      statisticsPageController.selectedFilters2 ==
                              StatisticsFilters.Temperature
                          ? 1
                          : statisticsPageController.selectedFilters2 ==
                                  StatisticsFilters.Humidity
                              ? 2
                              : statisticsPageController.selectedFilters2 ==
                                      StatisticsFilters.Rainfall
                                  ? 128
                                  : 5,
                  secondaryDesiredIntervals:
                      statisticsPageController.selectedFilters2 ==
                              StatisticsFilters.Temperature
                          ? 1
                          : statisticsPageController.selectedFilters2 ==
                                  StatisticsFilters.Humidity
                              ? 2
                              : statisticsPageController.selectedFilters2 ==
                                      StatisticsFilters.Rainfall
                                  ? 128
                                  : 5,
                ),
        ),
      ),
    );
  }

  Widget _buildViewGraphInitializationViewWeb({
    @required ViewGraphPageController controller,
    @required StatisticsPageController statisticsPageController,
  }) {
    return Scaffold();
  }
}

class ViewGraphParams {
  final StatisticsPageController statisticsPageController;

  ViewGraphParams({
    @required this.statisticsPageController,
  });
}
