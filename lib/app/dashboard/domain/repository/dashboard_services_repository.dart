import '../entity/live_weather_entity.dart';

abstract class DashboardServicesRepository {
  Future<LiveWeatherEntity> fetchLiveWeather();
}
