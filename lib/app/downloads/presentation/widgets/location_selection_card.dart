import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/app_theme.dart';
import '../downloads_controller.dart';

class LocationSelectionCard extends StatefulWidget {
  final SelectionListType selectionListType;
  final DownloadsPageController controller;
  final isWeb;

  const LocationSelectionCard({
    @required this.controller,
    @required this.selectionListType,
    @required this.isWeb,
  });

  @override
  _LocationSelectionCardState createState() => _LocationSelectionCardState();
}

class _LocationSelectionCardState extends State<LocationSelectionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isWeb
          ? MediaQuery.of(context).size.width / 2.5
          : MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: AppTheme.popupCardDecoration,
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
      child: Container(
        height: widget.isWeb ? 500 : MediaQuery.of(context).size.height / 1.98,
        width: widget.isWeb
            ? MediaQuery.of(context).size.width * 0.35
            : MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: widget.isWeb
                  ? 400
                  : MediaQuery.of(context).size.height / 1.81,
              child: ListView(
                children: <Widget>[
                  for (int k = 0;
                      k <
                          (widget.selectionListType == SelectionListType.STATE
                              ? widget.controller.stateList.length
                              : widget.controller.districtList.length);
                      k++)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: AppTheme.popupCardListViewDecoration,
                      child: Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Expanded(
                            flex: 10,
                            child: widget.selectionListType ==
                                    SelectionListType.STATE
                                ? Text(widget.controller.stateList[k]['name'])
                                : Text(
                                    widget.controller.districtList[k]['name']),
                          ),
                          Flexible(
                            flex: 1,
                            child: Checkbox(
                              value: widget.selectionListType ==
                                      SelectionListType.STATE
                                  ? widget.controller.selectedStates.contains(
                                      widget.controller.stateList[k]['id'],
                                    )
                                  : widget.controller.selectedDistricts
                                      .contains(
                                      widget.controller.districtList[k]['id'],
                                    ),
                              onChanged: (bool value) {
                                if (widget.selectionListType ==
                                    SelectionListType.STATE) {
                                  widget.controller.handleCheckBoxChangeOfState(
                                    value,
                                    widget.controller.stateList[k]['id'],
                                  );
                                } else if (widget.selectionListType ==
                                    SelectionListType.DISTRICT) {
                                  widget.controller
                                      .handleCheckBoxChangeOfDistrict(
                                    value,
                                    widget.controller.districtList[k]['id'],
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (widget.selectionListType == SelectionListType.STATE) {
                    print('Changed states');
                    widget.controller.selectedStateChange();
                    widget.controller.handleStateFilterClicked();
                  } else if (widget.selectionListType ==
                      SelectionListType.DISTRICT) {
                    print('Changed district');
                    widget.controller.selectedDistrictChanged();
                    widget.controller.handleDistrictFilterClicked();
                  }
                },
                child: Center(
                  child: Container(
                    decoration: AppTheme.doneButtonDecoration,
                    width: 60,
                    height: 30,
                    child: Center(
                      child: Text(
                        "Done",
                        style: AppTheme.navigationTabSelectedTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
