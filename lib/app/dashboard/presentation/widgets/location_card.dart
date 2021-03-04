import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';

class LocationCard extends StatelessWidget {
  final String state;
  final String district;

  const LocationCard({
    @required this.state,
    @required this.district,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.all(9.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'State: ',
              style: AppTheme.headingBoldText.copyWith(fontSize: 17),
            ),
            Text(
              state,
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'District: ',
              style: AppTheme.headingBoldText.copyWith(fontSize: 17),
            ),
            Text(
              district,
              style: TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
