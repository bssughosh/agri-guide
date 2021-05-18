import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repository/dashboard_services_repository.dart';

class FetchLocationDetailsForNewLocationUsecase
    extends CompletableUseCase<FetchLocationDetailsForNewLocationParams> {
  DashboardServicesRepository? _repository;

  FetchLocationDetailsForNewLocationUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      FetchLocationDetailsForNewLocationParams? params) async {
    StreamController streamController = StreamController();

    try {
      await _repository!.fetchLatitudeAndLongitudeForNewLocation(
        state: params!.state,
        district: params.district,
        pincode: params.pincode,
      );
      print('Location details fetched');
      streamController.close();
    } catch (error) {
      print('Location details not fetched');
      streamController.addError(error);
    }

    return streamController.stream;
  }
}

class FetchLocationDetailsForNewLocationParams {
  final String? state;
  final String? district;
  final String pincode;

  FetchLocationDetailsForNewLocationParams({
    required this.state,
    required this.district,
    required this.pincode,
  });
}
