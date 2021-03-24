import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/custom_icons_icons.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../dashboard_controller.dart';
import '../widgets/live_weather_card.dart';

Widget contentBody({
  @required BuildContext context,
  @required DashboardPageController controller,
}) {
  bool _showStateList = !controller.stateListLoading;
  bool _showDistrictList =
      controller.selectedState != null && !controller.districtListLoading;
  return Container(
    width: MediaQuery.of(context).size.width,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40),
          if (controller.liveWeatherEntity == null ||
              controller.isFetchingLiveWeather)
            CircularProgressIndicator(),
          if (_showStateList)
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: AppTheme.normalBlackBorderDecoration,
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, bottom: 10),
                      child: Text(
                        'State: ',
                        style: AppTheme.headingBoldText.copyWith(fontSize: 17),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    child: CustomDropdown(
                      hintText: 'Select State',
                      itemsList: controller.stateItems(),
                      selectedItem: controller.selectedState,
                      onChanged: (String newValue) {
                        controller.selectedState = newValue;
                        controller.selectedStateChange();
                      },
                    ),
                  ),
                  if (_showDistrictList) SizedBox(height: 20),
                  if (_showDistrictList)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 10),
                        child: Text(
                          'District: ',
                          style:
                              AppTheme.headingBoldText.copyWith(fontSize: 17),
                        ),
                      ),
                    ),
                  if (_showDistrictList) SizedBox(height: 5),
                  if (_showDistrictList)
                    Container(
                      width: double.infinity,
                      child: CustomDropdown(
                        hintText: 'Select District',
                        itemsList: controller.districtItems(),
                        selectedItem: controller.selectedDistrict,
                        onChanged: (String newValue) {
                          controller.selectedDistrict = newValue;
                          controller.selectedDistrictChange();
                          _showMyDialog(
                              context: context, controller: controller);
                        },
                      ),
                    ),
                ],
              ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
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
