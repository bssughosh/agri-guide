import 'package:flutter/material.dart';

import '../app_theme.dart';

Widget chip({
  @required String label,
  @required Color color,
  @required Color textColor,
}) {
  return Chip(
    // labelPadding: EdgeInsets.all(5.0),
    label: Text(
      label,
      style: AppTheme.bodyBoldText.copyWith(color: textColor),
    ),
    backgroundColor: color,
    elevation: 3.0,
    shadowColor: Colors.grey[60],
    // padding: EdgeInsets.all(6.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(3),
    ),
  );
}
