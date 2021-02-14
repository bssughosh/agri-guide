import '../../../core/state_machine.dart';

class DownloadsStateMachine
    extends StateMachine<DownloadsState, DownloadsEvent> {
  DownloadsStateMachine() : super(DownloadsInitializationState(true));

  @override
  DownloadsState getStateOnEvent(DownloadsEvent event) {
    final eventType = event.runtimeType;
    DownloadsState newState = getCurrentState();
    switch (eventType) {
      case DownloadsInitializationEvent:
        DownloadsInitializationEvent newEvent = event;
        newState = DownloadsInitializationState(newEvent.isFirstLoad);
        break;
      case DownloadsInitializedEvent:
        newState = DownloadsInitializedState();
        break;
    }
    return newState;
  }
}

abstract class DownloadsState {}

class DownloadsInitializationState extends DownloadsState {
  final bool isFirstLoad;

  DownloadsInitializationState(this.isFirstLoad);
}

class DownloadsInitializedState extends DownloadsState {}

abstract class DownloadsEvent {}

class DownloadsInitializationEvent extends DownloadsEvent {
  final bool isFirstLoad;

  DownloadsInitializationEvent(this.isFirstLoad);
}

class DownloadsInitializedEvent extends DownloadsEvent {}
