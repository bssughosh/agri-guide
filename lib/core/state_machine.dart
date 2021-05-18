import 'package:flutter/foundation.dart';

abstract class StateMachine<State, Event> {
  State? _state;

  StateMachine(State initialState) {
    this._state = initialState;
  }

  @protected
  State getStateOnEvent(Event event);

  State? onEvent(Event event) {
    this._state = getStateOnEvent(event);
    return _state;
  }

  State? getCurrentState() {
    return _state;
  }
}
