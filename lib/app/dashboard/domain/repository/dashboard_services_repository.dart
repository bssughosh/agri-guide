import '../entity/live_weather_entity.dart';
import '../entity/location_entity.dart';

abstract class DashboardServicesRepository {
  Future<LocationEntity> fetchLatitudeAndLongitude();

  Future<LiveWeatherEntity> fetchLiveWeather();
}
