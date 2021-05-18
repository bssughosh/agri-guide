import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'mobile/display_initialized_view.dart';
import 'mobile/initialization_view.dart';
import 'mobile/input_initialized_view.dart';
import 'mobile/loading_view.dart';
import 'mobile/logged_out_view.dart';
import 'prediction_controller.dart';
import 'prediction_state_machine.dart';
import 'web/display_initialized_view.dart';
import 'web/input_initialized_view.dart';
import 'web/logged_out_view.dart';

class PredictionPage extends View {
  @override
  State<StatefulWidget> createState() => PredictionViewState();
}

class PredictionViewState
    extends ResponsiveViewState<PredictionPage, PredictionPageController> {
  PredictionViewState() : super(new PredictionPageController());

  @override
  Widget get desktopView => ControlledWidgetBuilder<PredictionPageController>(
        builder: (context, controller) {
          final currentStateType = controller.getCurrentState().runtimeType;

          switch (currentStateType) {
            case PredictionPageInitializationState:
              return buildPredictionInitializationView(
                controller: controller,
              );

            case PredictionPageLoggedOutState:
              return buildPredictionLoggedOutViewWeb(
                controller: controller,
                context: context,
              );

            case PredictionPageInputInitializedState:
              return buildPredictionInputInitializedViewWeb(
                context: context,
                controller: controller,
              );

            case PredictionPageDisplayInitializedState:
              return buildPredictionDisplayInitializedViewWeb(
                context: context,
                controller: controller,
              );

            case PredictionPageLoadingState:
              return buildPredictionLoadingView();
          }
          throw Exception("Unrecognized state $currentStateType encountered");
        },
      );

  @override
  Widget get mobileView => ControlledWidgetBuilder<PredictionPageController>(
        builder: (context, controller) {
          final currentStateType = controller.getCurrentState().runtimeType;

          switch (currentStateType) {
            case PredictionPageInitializationState:
              return buildPredictionInitializationView(
                controller: controller,
              );

            case PredictionPageLoggedOutState:
              return buildPredictionLoggedOutViewMobile(
                controller: controller,
                context: context,
              );

            case PredictionPageInputInitializedState:
              return buildPredictionInputInitializedViewMobile(
                context: context,
                controller: controller,
              );

            case PredictionPageDisplayInitializedState:
              return buildPredictionDisplayInitializedViewMobile(
                context: context,
                controller: controller,
              );

            case PredictionPageLoadingState:
              return buildPredictionLoadingView();
          }
          throw Exception("Unrecognized state $currentStateType encountered");
        },
      );

  @override
  Widget get tabletView => mobileView;

  @override
  Widget get watchView => throw UnimplementedError();
}
