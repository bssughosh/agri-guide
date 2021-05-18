import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'downloads_controller.dart';
import 'downloads_state_machine.dart';
import 'mobile/initialization_view.dart';
import 'mobile/initialized_view.dart';
import 'mobile/loading_view.dart';
import 'web/initialized_view.dart';

class DownloadsPage extends View {
  @override
  State<StatefulWidget> createState() => DownloadsViewState();
}

class DownloadsViewState
    extends ResponsiveViewState<DownloadsPage, DownloadsPageController> {
  DownloadsViewState() : super(new DownloadsPageController());

  @override
  Widget get desktopView => ControlledWidgetBuilder<DownloadsPageController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          switch (currentStateType) {
            case DownloadsInitializationState:
              DownloadsInitializationState newState = currentState;
              return buildDownloadsInitializationView(
                isFirstLoad: newState.isFirstLoad,
                isWeb: true,
                controller: controller,
              );

            case DownloadsInitializedState:
              return buildDownloadsInitializedViewWeb(
                controller: controller,
                context: context,
              );

            case DownloadsLoadingState:
              return buildDownloadsLoadingView();
          }
          throw Exception("Unrecognized state $currentStateType encountered");
        },
      );

  @override
  Widget get mobileView => ControlledWidgetBuilder<DownloadsPageController>(
        builder: (context, controller) {
          final currentState = controller.getCurrentState();
          final currentStateType = controller.getCurrentState().runtimeType;

          switch (currentStateType) {
            case DownloadsInitializationState:
              DownloadsInitializationState newState = currentState;
              return buildDownloadsInitializationView(
                isFirstLoad: newState.isFirstLoad,
                isWeb: false,
                controller: controller,
              );

            case DownloadsInitializedState:
              return buildDownloadsInitializedViewMobile(
                controller: controller,
                context: context,
              );

            case DownloadsLoadingState:
              return buildDownloadsLoadingView();
          }
          throw Exception("Unrecognized state $currentStateType encountered");
        },
      );

  @override
  Widget get tabletView => mobileView;

  @override
  Widget get watchView => throw UnimplementedError();
}
