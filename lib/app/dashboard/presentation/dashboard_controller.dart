import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../injection_container.dart';
import '../../navigation_service.dart';
import 'dashboard_presenter.dart';
import 'dashboard_state_machine.dart';

class DashboardPageController extends Controller {
  final DashboardPagePresenter _presenter;
  final DashboardPageStateMachine _stateMachine =
      new DashboardPageStateMachine();
  final navigationService = serviceLocator<NavigationService>();
  DashboardPageController()
      : _presenter = serviceLocator<DashboardPagePresenter>(),
        super();

  @override
  void initListeners() {}

  DashboardState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  @override
  dispose() {
    _presenter.dispose();
    super.dispose();
  }
}
