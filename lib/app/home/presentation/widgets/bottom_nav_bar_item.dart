import 'package:agri_guide/core/app_theme.dart';
import 'package:flutter/material.dart';

class BottomNavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Function onPressed;
  final String title;

  const BottomNavBarItem({
    @required this.icon,
    @required this.isSelected,
    @required this.onPressed,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
          icon: Icon(
            icon,
            size: 23,
            color: isSelected ? AppTheme.secondaryColor : Colors.black,
          ),
          onPressed: onPressed,
        ),
        Text(
          title,
          style: TextStyle(
            color: isSelected ? AppTheme.secondaryColor : Colors.black,
          ),
        ),
      ],
    );
  }
}
