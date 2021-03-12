import 'package:flutter/material.dart';

import '../app_theme.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function onPressed;
  final bool isOverlayRequired;

  const CustomButton({
    @required this.title,
    @required this.isActive,
    @required this.onPressed,
    @required this.isOverlayRequired,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        title,
        style: isActive
            ? AppTheme.buttonActiveTextStyle
            : AppTheme.buttonInactiveTextStyle,
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isActive
              ? AppTheme.secondaryColor
              : AppTheme.buttonInactiveBackgroundColor,
        ),
        overlayColor: MaterialStateProperty.all<Color>(
          isActive
              ? isOverlayRequired
                  ? AppTheme.primaryColor
                  : AppTheme.secondaryColor
              : AppTheme.buttonInactiveBackgroundColor,
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(5.0),
        ),
      ),
      onPressed: isActive ? onPressed : () {},
    );
  }
}
