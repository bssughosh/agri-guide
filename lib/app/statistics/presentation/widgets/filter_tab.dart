import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';

Widget filterTab({
  @required Function onPressed,
  @required bool isSelected,
  @required String text,
}) {
  return TextButton(
    onPressed: onPressed,
    child: Container(
      decoration: isSelected
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppTheme.secondaryColor,
            )
          : BoxDecoration(
              border: Border.all(
                color: AppTheme.secondaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
            ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : AppTheme.secondaryColor,
        ),
      ),
    ),
  );
}
