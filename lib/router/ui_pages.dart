import 'package:flutter/foundation.dart';

enum Pages {
  Splash,
  Home,
  Login,
  Register,
}

const String splashPage = '/splash';
const String homepage = '/home';
const String loginPage = '/login';
const String registerPage = '/register';

final _keyNameSplash = 'Splash';
final _keyNameHome = 'Home';
final _keyNameLogin = 'Login';
final _keyNameRegister = 'Register';

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;

  PageConfiguration({
    @required this.key,
    @required this.path,
    @required this.uiPage,
  });
}

final PageConfiguration splashPageConfig = PageConfiguration(
  key: _keyNameSplash,
  path: splashPage,
  uiPage: Pages.Splash,
);

final PageConfiguration homePageConfig = PageConfiguration(
  key: _keyNameHome,
  path: homepage,
  uiPage: Pages.Home,
);

final PageConfiguration loginPageConfig = PageConfiguration(
  key: _keyNameLogin,
  path: loginPage,
  uiPage: Pages.Login,
);

final PageConfiguration registerPageConfig = PageConfiguration(
  key: _keyNameRegister,
  path: registerPage,
  uiPage: Pages.Register,
);
