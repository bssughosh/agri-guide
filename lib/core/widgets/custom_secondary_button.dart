import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../app_theme.dart';

class CustomSecondaryButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function onPressed;

  const CustomSecondaryButton({
    required this.title,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed as void Function()?,
        child: Container(
          padding: EdgeInsets.all(6),
          child: Text(
            title,
            style: AppTheme.bodyBoldText.copyWith(
              fontSize: 14,
              color: AppTheme.navigationSelectedColor,
            ),
          ),
        ),
      ),
    );
  }
}
