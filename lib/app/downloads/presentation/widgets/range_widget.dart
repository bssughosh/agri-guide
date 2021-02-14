import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../downloads_controller.dart';

class RangeWidget extends StatelessWidget {
  final DownloadsPageController controller;
  final bool isFrom;

  const RangeWidget({this.controller, this.isFrom});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isFrom ? 'From' : 'To',
          style: AppTheme.headingBoldText,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: 80,
          child: TextField(
            controller: isFrom ? controller.fromText : controller.toText,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onChanged: (value) {
              if (value == null)
                controller.updateRangeYear(isFrom ? '1901' : '2019', isFrom);
              else
                controller.updateRangeYear('', isFrom);
            },
          ),
        ),
      ],
    );
  }
}
