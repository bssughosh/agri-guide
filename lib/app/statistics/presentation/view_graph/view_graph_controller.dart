import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../../injection_container.dart';
import '../../../navigation_service.dart';
import 'view_graph_presenter.dart';
import 'view_graph_state_machine.dart';

class ViewGraphPageController extends Controller {
  final ViewGraphPagePresenter _presenter;
  final ViewGraphPageStateMachine _stateMachine =
      new ViewGraphPageStateMachine();
  final navigationService = serviceLocator<NavigationService>();
  ViewGraphPageController()
      : _presenter = serviceLocator<ViewGraphPagePresenter>(),
        super();

  @override
  void initListeners() {}

  ViewGraphState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  @override
  dispose() {
    _presenter.dispose();
    super.dispose();
  }

  void handleBackPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
