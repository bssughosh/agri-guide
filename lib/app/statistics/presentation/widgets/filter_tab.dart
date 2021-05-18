import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';

Widget filterTab({
  required Function onPressed,
  required bool isSelected,
  required String text,
}) {
  return TextButton(
    onPressed: onPressed as void Function()?,
    child: Container(
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(
                color: AppTheme.secondaryColor,
                width: 2,
              ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.secondaryColor,
          ),
        ),
      ),
    ),
  );
}
