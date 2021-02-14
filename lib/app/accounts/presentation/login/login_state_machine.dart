import '../../../../core/state_machine.dart';

class LoginStateMachine extends StateMachine<LoginState, LoginEvent> {
  LoginStateMachine() : super(LoginInitializedState());

  @override
  LoginState getStateOnEvent(LoginEvent event) {
    final eventType = event.runtimeType;
    LoginState newState = getCurrentState();
    switch (eventType) {
      case LoginInitializedEvent:
        newState = LoginInitializedState();
        break;

      case LoginLoadingEvent:
        newState = LoginLoadingState();
        break;
    }
    return newState;
  }
}

class LoginState {}

class LoginInitializationState extends LoginState {}

class LoginInitializedState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginEvent {}

class LoginInitializedEvent extends LoginEvent {}

class LoginLoadingEvent extends LoginEvent {}
