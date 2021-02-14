import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../downloads_controller.dart';

class DownloadParamsSelectionBar extends StatefulWidget {
  final DownloadsPageController controller;
  final bool isWeb;

  const DownloadParamsSelectionBar({
    @required this.controller,
    @required this.isWeb,
  });

  @override
  _DownloadParamsSelectionBarState createState() =>
      _DownloadParamsSelectionBarState();
}

class _DownloadParamsSelectionBarState
    extends State<DownloadParamsSelectionBar> {
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
              child: Text(
                widget.controller.selectedParams.length == 0
                    ? 'Select Parameters to download'
                    : _getNameOfSelectedDownloadParamIds(),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: () {
                widget.controller.handleParamsFilterClicked();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getNameOfSelectedDownloadParamIds() {
    List<String> paramsNamesList = [];
    for (String id in widget.controller.selectedParams) {
      for (int j = 0; j < widget.controller.paramsList.length; j++) {
        if (id == widget.controller.paramsList[j]['id'])
          paramsNamesList.add(widget.controller.paramsList[j]['name']);
      }
    }
    return paramsNamesList.join(', ');
  }
}
