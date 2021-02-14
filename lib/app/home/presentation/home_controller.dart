import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../core/observer.dart';
import '../../../injection_container.dart';
import '../../accounts/domain/entities/user_entity.dart';
import '../../accounts/domain/repositories/firebase_authentication_repository.dart';
import '../../navigation_service.dart';
import 'home_presenter.dart';
import 'home_state_machine.dart';

class HomePageController extends Controller {
  final HomePagePresenter _presenter;
  final HomePageStateMachine _stateMachine = new HomePageStateMachine();
  final navigationService = serviceLocator<NavigationService>();
  HomePageController()
      : _presenter = serviceLocator<HomePagePresenter>(),
        super();

  int pageNumber = 0;
  int oldPageNumber = 0;

  LoginStatus loginStatus = LoginStatus.LOGGED_OUT;
  UserEntity userEntity;

  @override
  void initListeners() {}

  @override
  dispose() {
    _presenter.dispose();
    super.dispose();
  }

  HomePageState getCurrentState() {
    return _stateMachine.getCurrentState();
  }

  void changePageNumber(int newPageNo) {
    oldPageNumber = pageNumber;
    pageNumber = newPageNo;
    refreshUI();
  }

  void checkForLoginStatus() {
    _presenter.checkLoginStatus(
      new UseCaseObserver(() {}, (error) {
        print(error);
      }, onNextFunction: (LoginStatus status) {
        loginStatus = status;
        if (status == LoginStatus.LOGGED_OUT) {
          _stateMachine.onEvent(new HomePageInitializatedEvent());
          refreshUI();
        } else {
          _presenter.fetchUserDetails(
            new UseCaseObserver(
              () {},
              (error) {
                print(error);
              },
              onNextFunction: (UserEntity user) {
                userEntity = user;
                _stateMachine.onEvent(new HomePageInitializatedEvent());
                refreshUI();
              },
            ),
          );
        }
      }),
    );
  }

  void navigateToLogin() {
    navigationService.navigateTo(NavigationService.loginPage,
        shouldReplace: true);
  }

  void logoutUser() {
    _presenter.logoutUser(
      new UseCaseObserver(
        () {
          navigationService.navigateTo(NavigationService.homepage,
              shouldReplace: true);
        },
        (error) {
          print(error);
        },
      ),
    );
  }
}
