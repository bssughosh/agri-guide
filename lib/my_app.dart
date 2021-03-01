import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'injection_container.dart' as di;
import 'router/agri_guide_parser.dart';
import 'router/router_delegate.dart';
import 'router/ui_pages.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final delegate = di.serviceLocator<AgriGuideRouterDelegate>();
    final parser = AgriGuideParser();
    delegate.setNewRoutePath(splashPageConfig);
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
