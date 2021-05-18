import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../injection_container.dart';
import '../../../navigation_service.dart';
import 'view_graph_presenter.dart';
import 'view_graph_state_machine.dart';

class ViewGraphPageController extends Controller {
  final ViewGraphPagePresenter? _presenter;
  final ViewGraphPageStateMachine _stateMachine =
      new ViewGraphPageStateMachine();
  final NavigationService? navigationService = serviceLocator<NavigationService>();
  ViewGraphPageController()
      : _presenter = serviceLocator<ViewGraphPagePresenter>(),
        super();

  @override
  void initListeners() {}

  ViewGraphState? getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  @override
  void onInitState() {
    super.onInitState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void onDisposed() {
    _presenter!.dispose();
    super.onDisposed();
  }
}
