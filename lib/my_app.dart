import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/app_theme.dart';
import 'router/agri_guide_parser.dart';
import 'router/router_delegate.dart';
import 'router/ui_pages.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final delegate = AgriGuideRouterDelegate();
    final parser = AgriGuideParser();
    delegate.setNewRoutePath(splashPageConfig);
    Get.put(delegate);
    return MaterialApp.router(
      title: 'Agri Guide',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: AppTheme.primaryColor,
        accentColor: AppTheme.accentColor,
      ),
      routeInformationParser: parser,
      routerDelegate: delegate,
    );
  }
}
