import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entity/live_weather_entity.dart';
import '../repository/dashboard_services_repository.dart';

class FetchLiveWeatherForNewLocationUsecase
    extends CompletableUseCase<FetchLiveWeatherForNewLocationParams> {
  DashboardServicesRepository _repository;

  FetchLiveWeatherForNewLocationUsecase(this._repository);

  @override
  Future<Stream<LiveWeatherEntity>> buildUseCaseStream(
      FetchLiveWeatherForNewLocationParams params) async {
    StreamController<LiveWeatherEntity> streamController = StreamController();

    try {
      LiveWeatherEntity liveWeatherEntity =
          await _repository.fetchLiveWeatherForNewLocation(
        state: params.state,
        district: params.district,
        pincode: params.pincode,
      );
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

class FetchLiveWeatherForNewLocationParams {
  final String state;
  final String district;
  final String pincode;

  FetchLiveWeatherForNewLocationParams({
    @required this.state,
    @required this.district,
    @required this.pincode,
  });
}
