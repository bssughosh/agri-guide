import 'package:flutter/material.dart';

import '../app_theme.dart';

Widget chip({
  required String label,
  required Color color,
  required Color textColor,
  required double elevation,
}) {
  return Chip(
    label: Text(
      label,
      style: AppTheme.bodyBoldText.copyWith(color: textColor),
    ),
    backgroundColor: color,
    elevation: elevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(3),
    ),
  );
}
