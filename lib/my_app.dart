import 'package:flutter/material.dart';

import 'app/navigation_service.dart';
import 'core/app_theme.dart';
import 'injection_container.dart' as di;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri Guide',
      navigatorKey: di.serviceLocator<NavigationService>().navigatorKey,
      initialRoute: NavigationService.splashPage,
      onGenerateRoute: NavigationService.generateRoute,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: AppTheme.secondaryColor,
        accentColor: AppTheme.accentColor,
      ),
    );
  }
}
