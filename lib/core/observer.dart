import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class UseCaseObserver implements Observer<void> {
  final Function _onComplete;
  final Function _onError;
  final Function? onNextFunction;

  UseCaseObserver(this._onComplete, this._onError, {this.onNextFunction});
  @override
  void onComplete() {
    _onComplete();
  }

  @override
  void onError(e) {
    _onError(e);
  }

  @override
  void onNext(value) {
    onNextFunction!(value);
  }
}
