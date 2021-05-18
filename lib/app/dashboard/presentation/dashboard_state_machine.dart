import '../../../core/enums.dart';
import '../../../core/state_machine.dart';

class DashboardPageStateMachine
    extends StateMachine<DashboardState?, DashboardEvent> {
  DashboardPageStateMachine() : super(DashboardPageInitializationState());

  @override
  DashboardState? getStateOnEvent(DashboardEvent event) {
    final eventType = event.runtimeType;
    DashboardState? newState = getCurrentState();
    switch (eventType) {
      case DashboardPageInitializedEvent:
        DashboardPageInitializedEvent initializedEvent =
            event as DashboardPageInitializedEvent;
        newState = DashboardPageInitializedState(
          loginStatus: initializedEvent.loginStatus,
        );
        break;

      case DashboardPageLoadingEvent:
        newState = DashboardPageLoadingState();
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
    required this.loginStatus,
  });
}

class DashboardPageLoadingState extends DashboardState {}

class DashboardEvent {}

class DashboardPageInitializedEvent extends DashboardEvent {
  final LoginStatus loginStatus;

  DashboardPageInitializedEvent({
    required this.loginStatus,
  });
}

class DashboardPageLoadingEvent extends DashboardEvent {}
