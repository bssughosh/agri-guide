import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../injection_container.dart';
import '../../../router/router_delegate.dart';
import '../../../router/ui_pages.dart';
import 'splash_presenter.dart';
import 'splash_state_machine.dart';

class SplashPageController extends Controller {
  final SplashPagePresenter _presenter;
  final SplashStateMachine _stateMachine = new SplashStateMachine();
  SplashPageController()
      : _presenter = serviceLocator<SplashPagePresenter>(),
        super();

  @override
  void initListeners() {}

  SplashState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  @override
  dispose() {
    _presenter.dispose();
    super.dispose();
  }

  void navigateToHomepage() {
    final delegate = serviceLocator<AgriGuideRouterDelegate>();
    delegate.replace(homePageConfig);
  }
}
