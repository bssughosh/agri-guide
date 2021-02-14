import 'package:flutter/material.dart';

import 'accounts/presentation/login/login_view.dart';
import 'accounts/presentation/register/register_view.dart';
import 'home/presentation/home_view.dart';
import 'splash/presentation/splash_view.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static const String splashPage = '/splash';
  static const String homepage = '/home';
  static const String loginPage = '/login';
  static const String registerPage = '/register';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashPage:
        return MaterialPageRoute(builder: (_) => SplashPage());

      case homepage:
        return MaterialPageRoute(builder: (_) => HomePage());

      case loginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());

      case registerPage:
        return MaterialPageRoute(builder: (_) => RegisterPage());

      default:
        return null;
    }
  }

  Future<void> navigateTo(
    String routeName, {
    bool shouldReplace = false,
    Object arguments,
  }) {
    if (shouldReplace) {
      return navigatorKey.currentState.pushReplacementNamed(
        routeName,
        arguments: arguments,
      );
    }
    return navigatorKey.currentState.pushNamed(
      routeName,
      arguments: arguments,
    );
  }
}
