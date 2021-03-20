import '../../../core/state_machine.dart';

class PredictionPageStateMachine
    extends StateMachine<PredictionState, PredictionEvent> {
  PredictionPageStateMachine() : super(PredictionPageInitializationState());

  @override
  PredictionState getStateOnEvent(PredictionEvent event) {
    final eventType = event.runtimeType;
    PredictionState newState = getCurrentState();
    switch (eventType) {
      case PredictionPageLoggedOutEvent:
        newState = PredictionPageLoggedOutState();
        break;

      case PredictionPageInputInitializedEvent:
        newState = PredictionPageInputInitializedState();
        break;

      case PredictionPageDisplayInitializedEvent:
        newState = PredictionPageDisplayInitializedState();
        break;

      case PredictionPageLoadingEvent:
        newState = PredictionPageLoadingState();
        break;
    }
    return newState;
  }
}

class PredictionState {}

class PredictionPageInitializationState extends PredictionState {}

class PredictionPageLoggedOutState extends PredictionState {}

class PredictionPageInputInitializedState extends PredictionState {}

class PredictionPageDisplayInitializedState extends PredictionState {}

class PredictionPageLoadingState extends PredictionState {}

class PredictionEvent {}

class PredictionPageLoggedOutEvent extends PredictionEvent {}

class PredictionPageInputInitializedEvent extends PredictionEvent {}

class PredictionPageDisplayInitializedEvent extends PredictionEvent {}

class PredictionPageLoadingEvent extends PredictionEvent {}
