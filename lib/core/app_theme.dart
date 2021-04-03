import 'package:flutter/material.dart';

/// A class conating all theming for the application
class AppTheme {
  // Colors
  static Color primaryColor = Color(0xFFA1CE69);

  static Color chipBackground = Color(0xFF8CC63E).withOpacity(0.25);

  static Color loginBackground = Color(0xFF8CC63E).withOpacity(0.85);

  static Color secondaryColor = Color(0xFF53732B);

  static Color accentColor = Color(0xFF53732B);

  static Color navigationSelectedColor = Color(0xFF1D5B70);

  static Color buttonActiveColor = Color(0xFF53732B);

  static Color buttonDeactiveColor = Colors.grey;

  static Color selectionBarColor = Colors.grey[300].withOpacity(.8);

  static Color customTableBorderColor = Colors.black26;

  static Color buttonInactiveBackgroundColor = Color(0xFFCCCCCC);

  // Text styles
  static TextStyle bodyRegularText = TextStyle(fontFamily: 'Roboto');

  static TextStyle bodyBoldText = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyItalicText = TextStyle(
    fontFamily: 'Roboto',
    fontStyle: FontStyle.italic,
  );

  static TextStyle headingRegularText = TextStyle(fontFamily: 'Oxygen');

  static TextStyle loginAnimatedText = TextStyle(
    fontFamily: 'Oxygen',
    color: Colors.black87,
    fontSize: 13,
    letterSpacing: 2,
  );

  static TextStyle headingBoldText = TextStyle(
    fontFamily: 'Oxygen',
    fontWeight: FontWeight.bold,
  );

  static TextStyle navigationTabSelectedTextStyle =
      bodyBoldText.copyWith(color: Colors.white);

  static TextStyle navigationTabDeselectedTextStyle =
      bodyRegularText.copyWith(color: Colors.white);

  static TextStyle customTableHeadingTextStyle =
      bodyRegularText.copyWith(color: Colors.white);

  static TextStyle buttonActiveTextStyle =
      bodyBoldText.copyWith(color: Colors.white);

  static TextStyle buttonInactiveTextStyle =
      bodyBoldText.copyWith(color: Color(0xFF9E9E9E));

  // Box decorations
  static BoxDecoration navigationTabSelectedDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    color: navigationSelectedColor,
  );

  static BoxDecoration navigationTabDeselectedDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    color: secondaryColor,
  );

  static BoxDecoration popupCardDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    border: Border.all(
      width: 0.5,
      color: Colors.grey[200],
    ),
    color: Colors.white,
  );

  static BoxDecoration popupCardListViewDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    border: Border.all(
      width: 1,
      color: Colors.blueGrey,
    ),
  );

  static BoxDecoration doneButtonDecoration = BoxDecoration(
    color: secondaryColor,
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  );

  static BoxDecoration customTableHeadingCellDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(18),
    color: secondaryColor,
  );

  static BoxDecoration customTableRowCellDecoration = BoxDecoration(
    border: Border.all(color: Colors.black26),
    borderRadius: BorderRadius.circular(18),
  );

  static BoxDecoration normalGreenBorderDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: AppTheme.secondaryColor,
    ),
  );

  static BoxDecoration normalBlackBorderDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Colors.black12,
    ),
  );
}
