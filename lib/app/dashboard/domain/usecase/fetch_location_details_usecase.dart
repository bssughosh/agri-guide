import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entity/location_entity.dart';
import '../repository/dashboard_services_repository.dart';

class FetchLocationDetailsUsecase extends CompletableUseCase<void> {
  DashboardServicesRepository _repository;

  FetchLocationDetailsUsecase(this._repository);

  @override
  Future<Stream<LocationEntity>> buildUseCaseStream(void params) async {
    StreamController<LocationEntity> streamController = StreamController();

    try {
      await _repository.fetchLatitudeAndLongitude();
      print('Location details fetched');
      streamController.close();
    } catch (error) {
      print('Location details not fetched');
      streamController.addError(error);
    }

    return streamController.stream;
  }
}
