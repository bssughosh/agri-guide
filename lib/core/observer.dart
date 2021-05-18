import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class UseCaseObserver implements Observer<void> {
  final Function _onComplete;
  final Function _onError;
  final Function? onNextFunction;

  UseCaseObserver(this._onComplete, this._onError, {this.onNextFunction});
  @override
  void onComplete() {
    assert(_onComplete != null);
    _onComplete();
  }

  @override
  void onError(e) {
    assert(_onError != null);
    _onError(e);
  }

  @override
  void onNext(value) {
    onNextFunction!(value);
  }
}
