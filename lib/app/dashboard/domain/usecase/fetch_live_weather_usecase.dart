import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entity/live_weather_entity.dart';
import '../repository/dashboard_services_repository.dart';

class FetchLiveWeatherUsecase extends CompletableUseCase<void> {
  DashboardServicesRepository? _repository;

  FetchLiveWeatherUsecase(this._repository);

  @override
  Future<Stream<LiveWeatherEntity?>> buildUseCaseStream(void params) async {
    StreamController<LiveWeatherEntity?> streamController = StreamController();

    try {
      LiveWeatherEntity? liveWeatherEntity =
          await _repository!.fetchLiveWeather();
      print('Live weather fetched');
      streamController.add(liveWeatherEntity);
      streamController.close();
    } catch (error) {
      print('Live weather not fetched');
      streamController.addError(error);
    }

    return streamController.stream;
  }
}
