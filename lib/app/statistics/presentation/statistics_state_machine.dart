import '../../../core/state_machine.dart';

class StatisticsPageStateMachine
    extends StateMachine<StatisticsState, StatisticsEvent> {
  StatisticsPageStateMachine() : super(StatisticsPageInitializationState());

  @override
  StatisticsState getStateOnEvent(StatisticsEvent event) {
    final eventType = event.runtimeType;
    StatisticsState newState = getCurrentState();
    switch (eventType) {
      case StatisticsPageInputInitializedEvent:
        newState = StatisticsPageInputInitializedState();
        break;

      case StatisticsPageLoadingEvent:
        newState = StatisticsPageLoadingState();
        break;

      case StatisticsPageInitializedEvent:
        newState = StatisticsPageInitializedState();
        break;
    }
    return newState;
  }
}

class StatisticsState {}

class StatisticsPageInitializationState extends StatisticsState {}

class StatisticsPageLoadingState extends StatisticsState {}

class StatisticsPageInputInitializedState extends StatisticsState {}

class StatisticsPageInitializedState extends StatisticsState {}

class StatisticsEvent {}

class StatisticsPageInputInitializedEvent extends StatisticsEvent {}

class StatisticsPageLoadingEvent extends StatisticsEvent {}

class StatisticsPageInitializedEvent extends StatisticsEvent {}
