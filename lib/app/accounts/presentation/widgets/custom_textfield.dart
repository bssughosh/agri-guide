import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textController;
  final String title;
  final String hint;
  final Function onChanged;
  final bool obscureText;
  final List<String> autofillHints;

  const CustomTextField({
    @required this.textController,
    @required this.title,
    @required this.hint,
    @required this.onChanged,
    @required this.autofillHints,
    this.obscureText,
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
          obscureText: obscureText ?? false,
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
          autofillHints: autofillHints,
        ),
      ],
    );
  }
}
