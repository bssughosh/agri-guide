import '../../../core/state_machine.dart';

class PredictionPageStateMachine
    extends StateMachine<PredictionState, PredictionEvent> {
  PredictionPageStateMachine() : super(PredictionPageInitializationState());

  @override
  PredictionState getStateOnEvent(PredictionEvent event) {
    final eventType = event.runtimeType;
    PredictionState newState = getCurrentState();
    switch (eventType) {
      case PredictionPageInitializedEvent:
        newState = PredictionPageInitializedState();
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

class PredictionPageInitializedState extends PredictionState {}

class PredictionPageLoadingState extends PredictionState {}

class PredictionEvent {}

class PredictionPageInitializedEvent extends PredictionEvent {}

class PredictionPageLoadingEvent extends PredictionEvent {}
