import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';
import '../prediction_controller.dart';

class LocationSelectionBar extends StatefulWidget {
  final SelectionListType selectionListType;
  final PredictionPageController controller;
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
          ? MediaQuery.of(context).size.width / 3
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
                  ? MediaQuery.of(context).size.width / 3.2
                  : MediaQuery.of(context).size.width * 0.8,
              child: widget.selectionListType == SelectionListType.STATE
                  ? Text(
                      widget.controller.selectedState == ''
                          ? 'Select State'
                          : _getNameOfSelectedLocationIds(),
                    )
                  : Text(
                      widget.controller.selectedDistrict == ''
                          ? 'Select District'
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
      String stateName;
      for (int j = 0; j < widget.controller.stateList.length; j++) {
        if (widget.controller.selectedState ==
            widget.controller.stateList[j]['id'])
          stateName = widget.controller.stateList[j]['name'];
      }
      return stateName;
    } else if (widget.selectionListType == SelectionListType.DISTRICT) {
      String districtName;
      for (int j = 0; j < widget.controller.districtList.length; j++) {
        if (widget.controller.selectedDistrict ==
            widget.controller.districtList[j]['id'])
          districtName = widget.controller.districtList[j]['name'];
      }
      return districtName;
    } else {
      return "";
    }
  }
}
