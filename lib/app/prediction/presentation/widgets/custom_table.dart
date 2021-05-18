import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/enums.dart';

class CustomTable extends StatelessWidget {
  final TableType tableType;
  final List<String?> dataSource;
  final List<String?> months;
  final String columnName;

  const CustomTable({
    required this.tableType,
    required this.months,
    required this.dataSource,
    required this.columnName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '${(describeEnum(tableType))} PREDICTION',
                style: AppTheme.headingBoldText.copyWith(fontSize: 17),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            child: DataTable(
              showCheckboxColumn: false,
              headingTextStyle: AppTheme.headingBoldText
                  .copyWith(fontSize: 15, color: Colors.white),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5),
              ),
              headingRowColor:
                  MaterialStateProperty.all<Color>(AppTheme.secondaryColor),
              columns: <DataColumn>[
                DataColumn(
                  label: Center(child: Text('Month')),
                ),
                DataColumn(
                  label: Expanded(
                    child: Center(
                      child: Container(
                        child: Text(
                          columnName,
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              rows: <DataRow>[
                for (int i = 0; i < dataSource.length; i++)
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Center(child: Text(months[i]!))),
                      DataCell(Center(child: Text(dataSource[i]!))),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
