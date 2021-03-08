import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_dropdown.dart';

class RangeWidget extends StatelessWidget {
  final String title;
  final String hintText;
  final List<DropdownMenuItem> itemsList;
  final String selectedItem;
  final Function onChanged;

  const RangeWidget({
    @required this.title,
    @required this.hintText,
    @required this.itemsList,
    @required this.selectedItem,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: Column(
        children: [
          Text(
            title,
            style: AppTheme.bodyBoldText,
          ),
          SizedBox(height: 5),
          CustomDropdown(
            hintText: hintText,
            itemsList: itemsList,
            selectedItem: selectedItem,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}
