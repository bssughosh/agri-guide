import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'mobile/display_initialized_view.dart';
import 'mobile/initialization_view.dart';
import 'mobile/input_initialized_view.dart';
import 'mobile/loading_view.dart';
import 'mobile/logged_out_view.dart';
import 'prediction_controller.dart';
import 'prediction_state_machine.dart';

class PredictionPage extends View {
  @override
  State<StatefulWidget> createState() => PredictionViewState();
}

class PredictionViewState
    extends ResponsiveViewState<PredictionPage, PredictionPageController> {
  PredictionViewState() : super(new PredictionPageController());

  @override
  void initState() {
    controller.startMonth = controller.months[0];
    controller.endMonth = controller.months[1];
    super.initState();
  }

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case PredictionPageInitializationState:
        return buildPredictionInitializationView(
          controller: controller,
        );

      case PredictionPageLoggedOutState:
        return buildPredictionLoggedOutView(
          controller: controller,
        );

      case PredictionPageInputInitializedState:
        return buildPredictionInputInitializedViewMobile(
          context: context,
          controller: controller,
        );

      case PredictionPageDisplayInitializedState:
        return buildPredictionDisplayInitializedViewMobile();

      case PredictionPageLoadingState:
        return buildPredictionLoadingView();
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
      case PredictionPageInitializationState:
        return buildPredictionInitializationView(
          controller: controller,
        );

      case PredictionPageLoggedOutState:
        return buildPredictionLoggedOutView(
          controller: controller,
        );

      case PredictionPageLoadingState:
        return buildPredictionLoadingView();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }
}
