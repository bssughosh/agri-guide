import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/app_theme.dart';
import 'splash_controller.dart';
import 'splash_state_machine.dart';

class SplashPage extends View {
  @override
  State<StatefulWidget> createState() => SplashViewState();
}

class SplashViewState
    extends ResponsiveViewState<SplashPage, SplashPageController> {
  SplashViewState() : super(new SplashPageController());

  @override
  Widget buildMobileView() {
    final currentStateType = controller.getCurrentState().runtimeType;

    switch (currentStateType) {
      case SplashInitState:
        return _buildMobileSplashState();
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
      case SplashInitState:
        return _buildWebSplashState();
    }
    throw Exception("Unrecognized state $currentStateType encountered");
  }

  Widget _buildMobileSplashState() {
    Timer(Duration(seconds: 3), () => controller.navigateToHomepage());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/splash_logo.gif',
                  height: 200,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'AGRI GUIDE',
                  textAlign: TextAlign.center,
                  style: AppTheme.headingBoldText.copyWith(fontSize: 40),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebSplashState() {
    Timer(Duration(seconds: 4), () => controller.navigateToHomepage());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/splash_logo.gif',
                  height: 250,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'AGRI GUIDE',
                  textAlign: TextAlign.center,
                  style: AppTheme.headingBoldText.copyWith(fontSize: 40),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
