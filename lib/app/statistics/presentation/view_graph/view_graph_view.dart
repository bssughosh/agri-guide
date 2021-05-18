import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

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
  void dispose() {
    super.dispose();
    print('Dispose called');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget get desktopView => throw UnimplementedError();

  @override
  Widget get mobileView => ControlledWidgetBuilder<ViewGraphPageController>(
        builder: (context, controller) {
          final currentStateType = controller.getCurrentState().runtimeType;

          switch (currentStateType) {
            case ViewGraphPageInitializationState:
              return _buildViewGraphInitializationViewMobile(
                controller: controller,
                statisticsPageController:
                    widget.params.statisticsPageController,
              );
          }
          throw Exception("Unrecognized state $currentStateType encountered");
        },
      );

  @override
  Widget get tabletView => mobileView;

  @override
  Widget get watchView => throw UnimplementedError();

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
                  ? ' v/s ' +
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
                              : 1,
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
                                  : 1,
                )
              : doubleGraph(
                  xAxisName: 'Year',
                  visibleMinimum: 20,
                  maximumLabels: 15,
                  primaryYAxisName:
                      describeEnum(statisticsPageController.selectedFilters1),
                  primaryYAxisLabel: statisticsPageController.getAxisLabelName(
                      statisticsPageController.selectedFilters1),
                  secondaryYAxisName:
                      describeEnum(statisticsPageController.selectedFilters2),
                  secondaryYAxisLabel:
                      statisticsPageController.getAxisLabelName(
                          statisticsPageController.selectedFilters2),
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
                              : 1,
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
                                  : 1,
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
                                  : 1,
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
                                  : 1,
                ),
        ),
      ),
    );
  }
}

class ViewGraphParams {
  final StatisticsPageController statisticsPageController;

  ViewGraphParams({
    @required this.statisticsPageController,
  });
}
