// import 'package:flutter/material.dart';
// import 'package:multiselect_formfield/multiselect_formfield.dart';

// import '../app_theme.dart';

// class CustomMultiselectForm extends StatelessWidget {
//   final List<String> selectedItemList;
//   final String title;
//   final List dataSource;
//   final String displayKey;
//   final String valueKey;
//   final Function onSavedFunction;

//   const CustomMultiselectForm({
//     @required this.selectedItemList,
//     @required this.title,
//     @required this.dataSource,
//     @required this.displayKey,
//     @required this.valueKey,
//     @required this.onSavedFunction,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           // borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//         color: Colors.black,
//       )),
//       child: MultiSelectFormField(
//         initialValue: selectedItemList,
//         chipLabelStyle: TextStyle(
//           fontWeight: FontWeight.bold,
//           color: AppTheme.secondaryColor,
//         ),
//         dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
//         checkBoxActiveColor: AppTheme.primaryColor,
//         checkBoxCheckColor: Colors.white,
//         chipBackGroundColor: AppTheme.chipBackground,
//         fillColor: Colors.transparent,
//         dialogShapeBorder: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(12.0),
//           ),
//         ),
//         title: Text(
//           title,
//           style: AppTheme.headingBoldText.copyWith(fontSize: 17),
//         ),
//         hintWidget: Text('Please choose one or more'),
//         dataSource: dataSource,
//         textField: displayKey,
//         valueField: valueKey,
//         okButtonLabel: 'DONE',
//         cancelButtonLabel: 'CANCEL',
//         onSaved: (newValueSelected) {
//           onSavedFunction(List<String>.from(newValueSelected));
//         },
//       ),
//     );
//   }
// }
