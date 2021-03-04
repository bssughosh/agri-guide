import 'package:flutter/foundation.dart';

import '../../../core/state_machine.dart';
import '../../accounts/domain/repositories/firebase_authentication_repository.dart';

class DashboardPageStateMachine
    extends StateMachine<DashboardState, DashboardEvent> {
  DashboardPageStateMachine() : super(DashboardPageInitializationState());

  @override
  DashboardState getStateOnEvent(DashboardEvent event) {
    final eventType = event.runtimeType;
    DashboardState newState = getCurrentState();
    switch (eventType) {
      case DashboardPageInitializedEvent:
        DashboardPageInitializedEvent initializedEvent = event;
        newState = DashboardPageInitializedState(
          loginStatus: initializedEvent.loginStatus,
        );
        break;
    }
    return newState;
  }
}

class DashboardState {}

class DashboardPageInitializationState extends DashboardState {}

class DashboardPageInitializedState extends DashboardState {
  final LoginStatus loginStatus;

  DashboardPageInitializedState({
    @required this.loginStatus,
  });
}

class DashboardEvent {}

class DashboardPageInitializedEvent extends DashboardEvent {
  final LoginStatus loginStatus;

  DashboardPageInitializedEvent({
    @required this.loginStatus,
  });
}
