import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../app_theme.dart';
import 'chip.dart';

class CustomMultiselectForm extends StatelessWidget {
  final List<String> selectedItemList;
  final String title;
  final List dataSource;
  final String displayKey;
  final String valueKey;
  final Function onSavedFunction;

  const CustomMultiselectForm({
    @required this.selectedItemList,
    @required this.title,
    @required this.dataSource,
    @required this.displayKey,
    @required this.valueKey,
    @required this.onSavedFunction,
  });

  @override
  Widget build(BuildContext context) {
    void _showMultiSelect() async {
      final _items = dataSource
          .map((e) => MultiSelectItem(e[valueKey], e[displayKey]))
          .toList();
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return MultiSelectBottomSheet(
            items: _items,
            selectedColor: AppTheme.secondaryColor,
            initialValue: selectedItemList,
            title: Text(title),
            onConfirm: (values) {
              onSavedFunction(List<String>.from(values));
            },
            maxChildSize: 0.8,
            minChildSize: 0.5,
            initialChildSize: 0.8,
          );
        },
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.selectionBarColor,
      ),
      child: Row(
        children: [
          if (selectedItemList.length == 0)
            Expanded(
              child: Text(
                '$title',
                style: AppTheme.headingBoldText,
              ),
            ),
          if (selectedItemList.length != 0)
            Expanded(
              child: Wrap(
                spacing: 5.0,
                children: _findListOfSelectedItems(),
              ),
            ),
          Container(
            decoration: BoxDecoration(border: Border(left: BorderSide())),
            child: IconButton(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
                size: 40,
              ),
              onPressed: () {
                _showMultiSelect();
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _findListOfSelectedItems() {
    List<Widget> _res = [];
    for (String value in selectedItemList) {
      for (int j = 0; j < dataSource.length; j++) {
        if (value == dataSource[j][valueKey])
          _res.add(
            chip(
              label: dataSource[j][displayKey],
              color: AppTheme.chipBackground,
              textColor: AppTheme.secondaryColor,
            ),
          );
      }
    }

    return _res;
  }
}
