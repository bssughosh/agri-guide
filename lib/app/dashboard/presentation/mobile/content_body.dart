import 'package:flutter/material.dart';

import '../dashboard_controller.dart';
import '../widgets/live_weather_card.dart';
import '../widgets/location_card.dart';

Widget contentBody({
  @required BuildContext context,
  @required DashboardPageController controller,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: Column(
      children: [
        if (controller.liveWeatherEntity == null ||
            controller.isFetchingLiveWeather)
          CircularProgressIndicator(),
        if (controller.liveWeatherEntity != null &&
            !controller.isFetchingLiveWeather)
          LocationCard(
            district: controller.liveWeatherEntity.location.district,
            state: controller.liveWeatherEntity.location.state,
          ),
        if (controller.liveWeatherEntity != null &&
            !controller.isFetchingLiveWeather)
          SizedBox(height: 30),
        if (controller.liveWeatherEntity != null &&
            !controller.isFetchingLiveWeather)
          LiveWeatherCard(
            icon: Icons.thermostat_rounded,
            title: 'Temperature',
            value: controller.liveWeatherEntity.temp + ' \u2103',
          ),
        if (controller.liveWeatherEntity != null &&
            !controller.isFetchingLiveWeather)
          LiveWeatherCard(
            icon: Icons.opacity,
            title: 'Humidity',
            value: controller.liveWeatherEntity.humidity + ' %',
          ),
        if (controller.liveWeatherEntity != null &&
            !controller.isFetchingLiveWeather)
          LiveWeatherCard(
            icon: Icons.wb_cloudy,
            title: 'Rainfall',
            value: controller.liveWeatherEntity.rain + ' mm',
          ),
        if (controller.liveWeatherEntity != null &&
            !controller.isFetchingLiveWeather)
          SizedBox(height: 30),
        if (controller.liveWeatherEntity != null &&
            !controller.isFetchingLiveWeather)
          Center(
            child: InkWell(
              onTap: () {
                controller.fetchLiveWeather();
              },
              child: Icon(
                Icons.cached,
                size: 40,
                color: Colors.black,
              ),
            ),
          ),
      ],
    ),
  );
}
