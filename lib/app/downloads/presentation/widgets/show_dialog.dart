import 'package:flutter/material.dart';

Future<void> showMyDialog({
  @required BuildContext context,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Text('Download successful'),
        content: Text(
            'The required files were downloaded successfully to your device'),
        actions: <Widget>[
          TextButton(
            child: Text('OKAY'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
