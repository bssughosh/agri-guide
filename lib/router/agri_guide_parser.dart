import 'package:flutter/material.dart';

import 'ui_pages.dart';

class AgriGuideParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    if (uri.pathSegments.isEmpty) {
      return splashPageConfig;
    }

    final path = uri.pathSegments[0];
    switch (path) {
      case splashPage:
        return splashPageConfig;
      case loginPage:
        return loginPageConfig;
      case registerPage:
        return registerPageConfig;
      case homepage:
        return homePageConfig;

      default:
        return splashPageConfig;
    }
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.Splash:
        return const RouteInformation(location: splashPage);
      case Pages.Login:
        return const RouteInformation(location: loginPage);
      case Pages.Register:
        return const RouteInformation(location: registerPage);
      case Pages.Home:
        return const RouteInformation(location: homepage);

      default:
        return const RouteInformation(location: splashPage);
    }
  }
}
