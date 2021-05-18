import 'package:flutter/material.dart';

import '../app_theme.dart';

class CustomCheckboxTile extends StatelessWidget {
  final bool isSelected;
  final String? title;
  final Function onChanged;

  const CustomCheckboxTile({
    required this.isSelected,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            activeColor: AppTheme.secondaryColor,
            value: isSelected,
            onChanged: (value) {
              onChanged();
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: onChanged as void Function()?,
              child: Text(title!, style: AppTheme.bodyRegularText),
            ),
          )
        ],
      ),
    );
  }
}
