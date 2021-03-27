import '../../../../core/state_machine.dart';

class ViewGraphPageStateMachine
    extends StateMachine<ViewGraphState, ViewGraphEvent> {
  ViewGraphPageStateMachine() : super(ViewGraphPageInitializationState());

  @override
  ViewGraphState getStateOnEvent(ViewGraphEvent event) {
    throw UnimplementedError();
  }
}

class ViewGraphState {}

class ViewGraphPageInitializationState extends ViewGraphState {}

class ViewGraphEvent {}
