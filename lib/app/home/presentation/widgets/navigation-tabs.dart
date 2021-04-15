import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';

class NavigationTabs extends StatelessWidget {
  final String title;
  final bool condition;
  final IconData icon;

  const NavigationTabs({
    @required this.title,
    @required this.condition,
    @required this.icon,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          Text(
            title,
            style: condition
                ? AppTheme.navigationTabSelectedTextStyle
                : AppTheme.navigationTabDeselectedTextStyle,
          ),
        ],
      ),
    );
  }
}
