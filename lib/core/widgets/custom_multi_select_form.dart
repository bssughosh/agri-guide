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
    // ignore: unused_element
    void _showBottomModalMultiSelect() async {
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
            title: Text(
              title,
              style: AppTheme.headingBoldText.copyWith(fontSize: 16),
            ),
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

    void _showMultiSelect() async {
      final _items = dataSource
          .map((e) => MultiSelectItem(e[valueKey], e[displayKey]))
          .toList();
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return MultiSelectDialog(
            items: _items,
            selectedColor: AppTheme.secondaryColor,
            initialValue: selectedItemList,
            searchable: false,
            title: Text(
              title,
              style: AppTheme.headingBoldText.copyWith(fontSize: 16),
            ),
            onConfirm: (values) {
              onSavedFunction(List<String>.from(values));
            },
          );
        },
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
      decoration: AppTheme.normalBlackBorderDecoration,
      child: Row(
        children: [
          if (selectedItemList.length == 0)
            Expanded(
              child: Text(
                '$title',
                style:
                    AppTheme.headingBoldText.copyWith(color: Colors.grey[500]),
              ),
            ),
          if (selectedItemList.length != 0)
            Expanded(
              child: Wrap(
                spacing: 5.0,
                children: _findListOfSelectedItems(),
              ),
            ),
          IconButton(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () {
              _showMultiSelect();
            },
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
              elevation: 0,
            ),
          );
      }
    }

    return _res;
  }
}
