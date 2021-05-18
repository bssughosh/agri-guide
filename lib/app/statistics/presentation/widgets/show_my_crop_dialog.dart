import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../statistics_controller.dart';

Future<void> showMyCropDialog({
  required BuildContext context,
  required List cropList,
  required StatisticsPageController controller,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Text(
          'Crops',
          style: AppTheme.headingBoldText,
        ),
        content: Container(
          height: 200,
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cropList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(cropList[index]['name']),
                onTap: () {
                  controller.cropSelected(cropList[index]['crop_id'], context);
                },
              );
            },
          ),
        ),
      );
    },
  );
}
