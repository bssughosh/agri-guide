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

      case StatisticsPageDisplayInitializedEvent:
        newState = StatisticsPageDisplayInitializedState();
        break;
    }
    return newState;
  }
}

class StatisticsState {}

class StatisticsPageInitializationState extends StatisticsState {}

class StatisticsPageLoadingState extends StatisticsState {}

class StatisticsPageInputInitializedState extends StatisticsState {}

class StatisticsPageDisplayInitializedState extends StatisticsState {}

class StatisticsEvent {}

class StatisticsPageInputInitializedEvent extends StatisticsEvent {}

class StatisticsPageDisplayInitializedEvent extends StatisticsEvent {}

class StatisticsPageLoadingEvent extends StatisticsEvent {}
