import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../downloads_controller.dart';

class LocationSelectionBar extends StatefulWidget {
  final SelectionListType selectionListType;
  final DownloadsPageController controller;
  final bool isWeb;

  const LocationSelectionBar({
    @required this.controller,
    @required this.selectionListType,
    @required this.isWeb,
  });

  @override
  _LocationSelectionBarState createState() => _LocationSelectionBarState();
}

class _LocationSelectionBarState extends State<LocationSelectionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isWeb
          ? MediaQuery.of(context).size.width * 0.35
          : MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.fromLTRB(20, 5, 25, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.selectionBarColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              width: widget.isWeb
                  ? MediaQuery.of(context).size.width * 0.3
                  : MediaQuery.of(context).size.width * 0.95,
              child: widget.selectionListType == SelectionListType.STATE
                  ? Text(
                      widget.controller.selectedStates.length == 0
                          ? 'Select States'
                          : _getNameOfSelectedLocationIds(),
                    )
                  : Text(
                      widget.controller.selectedDistricts.length == 0
                          ? 'Select Districts'
                          : _getNameOfSelectedLocationIds(),
                    ),
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: () {
                if (widget.selectionListType == SelectionListType.STATE)
                  widget.controller.handleStateFilterClicked();
                else if (widget.selectionListType == SelectionListType.DISTRICT)
                  widget.controller.handleDistrictFilterClicked();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getNameOfSelectedLocationIds() {
    if (widget.selectionListType == SelectionListType.STATE) {
      List<String> stateNamesList = [];
      for (String id in widget.controller.selectedStates) {
        for (int j = 0; j < widget.controller.stateList.length; j++) {
          if (id == widget.controller.stateList[j]['id'])
            stateNamesList.add(widget.controller.stateList[j]['name']);
        }
      }
      return stateNamesList.join(', ');
    } else if (widget.selectionListType == SelectionListType.DISTRICT) {
      List<String> districtNamesList = [];
      for (String id in widget.controller.selectedDistricts) {
        for (int j = 0; j < widget.controller.districtList.length; j++) {
          if (id == widget.controller.districtList[j]['id'])
            districtNamesList.add(widget.controller.districtList[j]['name']);
        }
      }
      return districtNamesList.join(', ');
    } else {
      return "";
    }
  }
}
