import 'package:get_it/get_it.dart';

import 'app/accounts/data/firebase_authentication_repository_impl.dart';
import 'app/accounts/domain/repositories/firebase_authentication_repository.dart';
import 'app/accounts/domain/usecase/check_login_status_usecase.dart';
import 'app/accounts/domain/usecase/create_new_user_usecase.dart';
import 'app/accounts/domain/usecase/login_with_email_and_password_usecase.dart';
import 'app/accounts/domain/usecase/logout_user_usecase.dart';
import 'app/accounts/presentation/login/login_presenter.dart';
import 'app/accounts/presentation/register/register_presenter.dart';
import 'app/dashboard/data/repository/dashboard_services_repository_impl.dart';
import 'app/dashboard/domain/repository/dashboard_services_repository.dart';
import 'app/dashboard/domain/usecase/fetch_live_weather_usecase.dart';
import 'app/dashboard/domain/usecase/fetch_location_details_usecase.dart';
import 'app/dashboard/presentation/dashboard_presenter.dart';
import 'app/downloads/data/repositories/fetch_input_repository_impl.dart';
import 'app/downloads/domain/repositories/fetch_input_repository.dart';
import 'app/downloads/domain/usecase/fetch_crop_list_usecase.dart';
import 'app/downloads/domain/usecase/fetch_district_list_usecase.dart';
import 'app/downloads/domain/usecase/fetch_seasons_list_usecase.dart';
import 'app/downloads/domain/usecase/fetch_state_list_usecase.dart';
import 'app/downloads/domain/usecase/get_required_downloads_usecase.dart';
import 'app/downloads/domain/usecase/get_required_mobile_downloads_usecase.dart';
import 'app/downloads/presentation/downloads_presenter.dart';
import 'app/home/presentation/home_presenter.dart';
import 'app/navigation_service.dart';
import 'app/prediction/data/repositories/agri_guide_prediction_repository_impl.dart';
import 'app/prediction/domain/repositories/agri_guide_prediction_repository.dart';
import 'app/prediction/domain/usecase/fetch_user_details_usecase.dart';
import 'app/prediction/domain/usecase/make_prediction_usecase.dart';
import 'app/prediction/presentation/prediction_presenter.dart';
import 'app/splash/presentation/splash_presenter.dart';
import 'app/statistics/data/repositories/statistics_repository_impl.dart';
import 'app/statistics/domain/repositories/statistics_repository.dart';
import 'app/statistics/domain/usecases/fetch_whole_data_usecase.dart';
import 'app/statistics/presentation/statistics_presenter.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator.registerLazySingleton(() => NavigationService());

  //splash
  serviceLocator.registerFactory(() => SplashPagePresenter());

  // home page
  serviceLocator.registerFactory(() => HomePagePresenter(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));

  // dashboard
  serviceLocator.registerLazySingleton<DashboardServicesRepository>(
      () => (DashboardServicesRepositoryImpl()));
  serviceLocator.registerFactory(
    () => DashboardPagePresenter(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );

  serviceLocator
      .registerFactory(() => FetchLiveWeatherUsecase(serviceLocator()));
  serviceLocator
      .registerFactory(() => FetchLocationDetailsUsecase(serviceLocator()));

  // downloads page
  serviceLocator.registerLazySingleton<FetchInputRepository>(
      () => (FetchInputRepositoryImpl()));
  serviceLocator.registerFactory(
    () => DownloadsPagePresenter(
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(() => FetchStateListUsecase(serviceLocator()));
  serviceLocator
      .registerFactory(() => FetchDistrictListUsecase(serviceLocator()));
  serviceLocator
      .registerFactory(() => FetchSeasonsListUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => FetchCropListUsecase(serviceLocator()));
  serviceLocator
      .registerFactory(() => GetRequiredDownloadsUsecase(serviceLocator()));
  serviceLocator.registerFactory(
      () => GetRequiredMobileDownloadsUsecase(serviceLocator()));

  //accounts
  serviceLocator.registerLazySingleton<FirebaseAuthenticationRepository>(
      () => (FirebaseAuthenticationRepositoryImpl()));
  serviceLocator.registerFactory(() => LoginPagePresenter(serviceLocator()));
  serviceLocator.registerFactory(() => RegisterPagePresenter(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator.registerFactory(
      () => LoginWithEmailAndPasswordUsecase(serviceLocator()));
  serviceLocator
      .registerFactory(() => CheckLoginStatusUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => CreateNewUserUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => LogoutUserUsecase(serviceLocator()));

  //prediction
  serviceLocator.registerLazySingleton<AgriGuidePredictionRepository>(
      () => (AgriGuidePredictionRepositoryImpl()));
  serviceLocator.registerFactory(() => PredictionPagePresenter(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator
      .registerFactory(() => FetchUserDetailsUsecase(serviceLocator()));
  serviceLocator.registerFactory(() => MakePredictionUsecase(serviceLocator()));

  //statistics
  serviceLocator.registerLazySingleton<StatisticsRepository>(
      () => (StatisticsRepositoryImpl()));
  serviceLocator.registerFactory(() => StatisticsPagePresenter(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ));

  serviceLocator.registerFactory(() => FetchWholeDataUsecase(serviceLocator()));
}

Future<void> reset() async {}
