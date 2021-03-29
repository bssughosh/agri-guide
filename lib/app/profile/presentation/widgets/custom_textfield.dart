import 'package:agri_guide/core/app_theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textController;
  final String title;
  final String hint;
  final Function onChanged;
  final bool isEnabled;

  const CustomTextField({
    @required this.textController,
    @required this.title,
    @required this.hint,
    @required this.onChanged,
    @required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 10),
            child: Text(
              title,
              style: AppTheme.headingBoldText.copyWith(fontSize: 15),
            ),
          ),
        ),
        TextField(
          enabled: isEnabled,
          controller: textController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onChanged: (value) {
            onChanged();
          },
        ),
      ],
    );
  }
}
