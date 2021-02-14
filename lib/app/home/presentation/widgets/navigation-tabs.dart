import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';

class NavigationTabs extends StatelessWidget {
  final String title;
  final bool condition;

  const NavigationTabs({
    @required this.title,
    @required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),
      decoration: condition
          ? AppTheme.navigationTabSelectedDecoration
          : AppTheme.navigationTabDeselectedDecoration,
      child: Text(
        title,
        style: condition
            ? AppTheme.navigationTabSelectedTextStyle
            : AppTheme.navigationTabDeselectedTextStyle,
      ),
    );
  }
}
