import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'mobile/initialization_view.dart';
import 'mobile/loading_view.dart';
import 'mobile/logged_in_view.dart';
import 'mobile/logged_out_view.dart';
import 'profile_controller.dart';
import 'profile_state_machine.dart';

class ProfilePage extends View {
  @override
  State<StatefulWidget> createState() => ProfileViewState();
}

class ProfileViewState
    extends ResponsiveViewState<ProfilePage, ProfilePageController> {
  ProfileViewState() : super(new ProfilePageController());

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case ProfilePageInitializationState:
        return buildProfileInitializationView(
          controller: controller,
        );

      case ProfilePageLoggedOutState:
        return buildProfileLoggedOutViewMobile(
          controller: controller,
          context: context,
        );

      case ProfilePageLoggedInState:
        return buildProfileLoggedInViewMobile(
          controller: controller,
          context: context,
        );

      case ProfilePageLoadingState:
        return buildProfileLoadingViewMobile();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  @override
  Widget buildTabletView() {
    return buildMobileView();
  }

  @override
  Widget buildDesktopView() {
    return buildMobileView(); //TODO: Change view
  }
}
