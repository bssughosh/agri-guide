import '../../../core/state_machine.dart';

class HomePageStateMachine extends StateMachine<HomePageState, HomePageEvent> {
  HomePageStateMachine() : super(new HomePageInitializationState());

  @override
  HomePageState getStateOnEvent(HomePageEvent event) {
    final eventType = event.runtimeType;
    HomePageState newState = getCurrentState();
    switch (eventType) {
      case HomePageInitializatedEvent:
        newState = HomePageInitializedState();
        break;
    }
    return newState;
  }
}

abstract class HomePageState {}

class HomePageInitializationState implements HomePageState {}

class HomePageInitializedState implements HomePageState {}

abstract class HomePageEvent {}

class HomePageInitializatedEvent extends HomePageEvent {}
