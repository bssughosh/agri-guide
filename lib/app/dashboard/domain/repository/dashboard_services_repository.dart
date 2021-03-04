import '../entity/live_weather_entity.dart';

abstract class DashboardServicesRepository {
  Future<void> fetchLatitudeAndLongitude();

  Future<LiveWeatherEntity> fetchLiveWeather();
}
