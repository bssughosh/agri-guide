import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/app_theme.dart';
import '../downloads_controller.dart';

class DownloadParamsSelectionCard extends StatefulWidget {
  final DownloadsPageController controller;
  final bool isWeb;

  const DownloadParamsSelectionCard({
    @required this.controller,
    @required this.isWeb,
  });

  @override
  _DownloadParamsSelectionCardState createState() =>
      _DownloadParamsSelectionCardState();
}

class _DownloadParamsSelectionCardState
    extends State<DownloadParamsSelectionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isWeb
          ? MediaQuery.of(context).size.width / 2.5
          : MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: AppTheme.popupCardDecoration,
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
      child: Center(
        child: Container(
          height:
              widget.isWeb ? 500 : MediaQuery.of(context).size.height / 1.98,
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
                    ? 180
                    : MediaQuery.of(context).size.height / 2.34,
                child: ListView(
                  children: <Widget>[
                    for (int k = 0;
                        k < widget.controller.paramsList.length;
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
                              child: Text(
                                widget.controller.paramsList[k]['name'],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Checkbox(
                                value:
                                    widget.controller.selectedParams.contains(
                                  widget.controller.paramsList[k]['id'],
                                ),
                                onChanged: (bool value) {
                                  widget.controller
                                      .handleCheckBoxChangeOfParams(
                                    value,
                                    widget.controller.paramsList[k]['id'],
                                  );
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
                    print('Changed Params');
                    widget.controller.selectedParamsChanged();
                    widget.controller.handleParamsFilterClicked();
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
      ),
    );
  }
}
