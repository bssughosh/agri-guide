import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';

class LiveWeatherCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const LiveWeatherCard({
    @required this.icon,
    @required this.title,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: Icon(
            icon,
            size: 40,
            color: Colors.black,
          ),
          title: Text(
            title,
            style: AppTheme.headingBoldText.copyWith(fontSize: 17),
          ),
          trailing: Text(
            value,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
