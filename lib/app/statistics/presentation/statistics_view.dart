import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'mobile/display_initialized_view.dart';
import 'mobile/initialization_view.dart';
import 'mobile/input_initialized_view.dart';
import 'mobile/loading_view.dart';
import 'statistics_controller.dart';
import 'statistics_state_machine.dart';
import 'web/display_initialized_view.dart';
import 'web/initialization_view.dart';
import 'web/input_initialized_view.dart';

class StatisticsPage extends View {
  @override
  State<StatefulWidget> createState() => StatisticsViewState();
}

class StatisticsViewState
    extends ResponsiveViewState<StatisticsPage, StatisticsPageController> {
  StatisticsViewState() : super(new StatisticsPageController());

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case StatisticsPageInitializationState:
        return buildStatisticsInitializationViewMobile(controller: controller);

      case StatisticsPageInputInitializedState:
        return buildStatisticsInputInitializedViewMobile(
          controller: controller,
          context: context,
        );

      case StatisticsPageDisplayInitializedState:
        return buildStatisticsDisplayInitializedViewMobile(
          controller: controller,
          context: context,
        );

      case StatisticsPageLoadingState:
        return buildStatisticsLoadingView();
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
      case StatisticsPageInitializationState:
        return buildStatisticsInitializationViewWeb(controller: controller);

      case StatisticsPageInputInitializedState:
        return buildStatisticsInputInitializedViewWeb(
          controller: controller,
          context: context,
        );

      case StatisticsPageDisplayInitializedState:
        return buildStatisticsDisplayInitializedViewWeb(controller: controller);

      case StatisticsPageLoadingState:
        return buildStatisticsLoadingView();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData({
    @required this.x,
    @required this.y,
    @required this.color,
  });
}
