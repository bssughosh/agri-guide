import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../splash_controller.dart';

Widget buildSplashInitViewWeb({
  @required SplashPageController controller,
  @required BuildContext context,
}) {
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
