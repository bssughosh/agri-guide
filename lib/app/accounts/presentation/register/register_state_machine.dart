import '../../../../core/state_machine.dart';

class RegisterStateMachine extends StateMachine<RegisterState?, RegisterEvent> {
  RegisterStateMachine() : super(RegisterInitializedState());

  @override
  RegisterState? getStateOnEvent(RegisterEvent event) {
    final eventType = event.runtimeType;
    RegisterState? newState = getCurrentState();

    switch (eventType) {
      case RegisterInitializedEvent:
        newState = RegisterInitializedState();
        break;

      case RegisterLoadingEvent:
        newState = RegisterLoadingState();
        break;
    }
    return newState;
  }
}

class RegisterState {}

class RegisterInitializedState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterEvent {}

class RegisterInitializedEvent extends RegisterEvent {}

class RegisterLoadingEvent extends RegisterEvent {}
