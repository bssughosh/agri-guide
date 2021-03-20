import 'package:flutter/material.dart';

import '../../../../core/custom_icons_icons.dart';
import '../dashboard_controller.dart';
import '../widgets/live_weather_card.dart';
import '../widgets/location_card.dart';

Widget contentBody({
  @required BuildContext context,
  @required DashboardPageController controller,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: SingleChildScrollView(
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
              icon: CustomIcons.temp_logo_live_weather,
              title: 'Temperature',
              value: controller.liveWeatherEntity.temp + ' \u2103',
            ),
          if (controller.liveWeatherEntity != null &&
              !controller.isFetchingLiveWeather)
            LiveWeatherCard(
              icon: CustomIcons.humidity_logo_live_weather,
              title: 'Humidity',
              value: controller.liveWeatherEntity.humidity + ' %',
            ),
          if (controller.liveWeatherEntity != null &&
              !controller.isFetchingLiveWeather)
            LiveWeatherCard(
              icon: CustomIcons.rainfall_logo_live_weather,
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
    ),
  );
}

Future<void> _showMyDialog({
  @required BuildContext context,
  @required DashboardPageController controller,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Pincode'),
        content: TextField(
          controller: controller.pincode,
          decoration: InputDecoration(
            fillColor: Colors.white,
            labelText: 'Pincode',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onChanged: (value) {
            controller.textFieldChanged();
          },
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Done'),
            onPressed: () {
              if (controller.pincode.text.length == 6) {
                controller.fetchLiveWeatherForNewLocation();
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
