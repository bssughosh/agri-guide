import 'package:flutter/material.dart';

import '../app_theme.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final List<DropdownMenuItem> itemsList;
  final String selectedItem;
  final Function onChanged;

  const CustomDropdown({
    @required this.hintText,
    @required this.itemsList,
    @required this.selectedItem,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.secondaryColor,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text(hintText, style: AppTheme.bodyItalicText),
          value: selectedItem,
          onChanged: (newValue) {
            onChanged(newValue.toString());
          },
          items: itemsList,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
            size: 32,
          ),
        ),
      ),
    );
  }
}
