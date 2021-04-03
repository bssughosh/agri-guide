import 'dart:async';

import 'package:flutter/material.dart';

import '../splash_controller.dart';

Widget buildSplashInitViewWeb({
  @required SplashPageController controller,
  @required BuildContext context,
}) {
  Timer(Duration(seconds: 2), () => controller.navigateToHomepage());
  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/splash_web.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}
