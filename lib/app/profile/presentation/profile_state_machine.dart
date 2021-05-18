import '../../../core/state_machine.dart';

class ProfilePageStateMachine extends StateMachine<ProfileState?, ProfileEvent> {
  ProfilePageStateMachine() : super(ProfilePageInitializationState());

  @override
  ProfileState? getStateOnEvent(ProfileEvent event) {
    final eventType = event.runtimeType;
    ProfileState? newState = getCurrentState();
    switch (eventType) {
      case ProfilePageInitializationEvent:
        newState = ProfilePageInitializationState();
        break;

      case ProfilePageLoggedOutEvent:
        newState = ProfilePageLoggedOutState();
        break;

      case ProfilePageLoggedInEvent:
        newState = ProfilePageLoggedInState();
        break;

      case ProfilePageLoadingEvent:
        newState = ProfilePageLoadingState();
        break;
    }
    return newState;
  }
}

class ProfileState {}

class ProfilePageInitializationState extends ProfileState {}

class ProfilePageLoggedOutState extends ProfileState {}

class ProfilePageLoggedInState extends ProfileState {}

class ProfilePageLoadingState extends ProfileState {}

class ProfileEvent {}

class ProfilePageInitializationEvent extends ProfileEvent {}

class ProfilePageLoggedOutEvent extends ProfileEvent {}

class ProfilePageLoggedInEvent extends ProfileEvent {}

class ProfilePageLoadingEvent extends ProfileEvent {}
