import '../../../core/state_machine.dart';

class SplashStateMachine extends StateMachine<SplashState, SplashEvent> {
  SplashStateMachine() : super(SplashInitState());

  @override
  SplashState getStateOnEvent(SplashEvent event) {
    throw UnimplementedError();
  }
}

class SplashState {}

class SplashInitState extends SplashState {}

class SplashEvent {}
