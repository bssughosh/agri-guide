import '../../../core/state_machine.dart';

class ProfilePageStateMachine extends StateMachine<ProfileState, ProfileEvent> {
  ProfilePageStateMachine() : super(ProfilePageInitializationState());

  @override
  ProfileState getStateOnEvent(ProfileEvent event) {
    final eventType = event.runtimeType;
    ProfileState newState = getCurrentState();
    switch (eventType) {
      case ProfilePageInitializationEvent:
        newState = ProfilePageInitializationState();
        break;

      case ProfilePageInitializedEvent:
        newState = ProfilePageInitializedState();
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

class ProfilePageInitializedState extends ProfileState {}

class ProfilePageLoadingState extends ProfileState {}

class ProfileEvent {}

class ProfilePageInitializationEvent extends ProfileEvent {}

class ProfilePageInitializedEvent extends ProfileEvent {}

class ProfilePageLoadingEvent extends ProfileEvent {}
