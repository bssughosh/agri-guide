import '../entity/live_weather_entity.dart';

abstract class DashboardServicesRepository {
  Future<void> fetchLatitudeAndLongitude();

  Future<LiveWeatherEntity?> fetchLiveWeather();

  Future<void> fetchLatitudeAndLongitudeForNewLocation({
    required String? state,
    required String? district,
    required String pincode,
  });

  Future<LiveWeatherEntity?> fetchLiveWeatherForNewLocation({
    required String? state,
    required String? district,
    required String pincode,
  });
}
