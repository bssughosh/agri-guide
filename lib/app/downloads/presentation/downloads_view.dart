import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'downloads_controller.dart';
import 'downloads_state_machine.dart';
import 'mobile/initialization_view.dart';
// import 'mobile/initialized_view.dart';
import 'mobile/initialized_view copy.dart';
import 'web/initialized_view.dart';

class DownloadsPage extends View {
  @override
  State<StatefulWidget> createState() => DownloadsViewState();
}

class DownloadsViewState
    extends ResponsiveViewState<DownloadsPage, DownloadsPageController> {
  DownloadsViewState() : super(new DownloadsPageController());

  @override
  void initState() {
    controller.years = controller.createYearsList();
    super.initState();
  }

  @override
  Widget buildMobileView() {
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
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  @override
  Widget buildTabletView() {
    return buildMobileView();
  }

  @override
  Widget buildDesktopView() {
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
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }
}
