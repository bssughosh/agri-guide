import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../statistics_controller.dart';

Future<void> showMySeasonDialog({
  @required BuildContext context,
  @required List seasonsList,
  @required StatisticsPageController controller,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Text(
          'Seasons',
          style: AppTheme.headingBoldText,
        ),
        content: Container(
          height: 200,
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: seasonsList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(seasonsList[index]),
                onTap: () {
                  controller.seasonSelected(seasonsList[index], context);
                },
              );
            },
          ),
        ),
      );
    },
  );
}
