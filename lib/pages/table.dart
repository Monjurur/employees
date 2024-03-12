import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTable extends StatelessWidget {
 // final String data;
  List<dynamic> tdata = [];
  late SharedPreferences sharedPreferences;

   CustomTable({super.key, required this.tdata});
  List<String> parseData(String data) {
    // Remove trailing semicolon and split the string by ';'
    // return data.substring(0, data.length - 1).split(';');
    return data
        .split(RegExp(r'[;\n\[\], ]'))
        .where((element) => element.isNotEmpty)
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    List<String> data1 = tdata.map((dynamic item) => item.toString()).toList();
    List<String> tableData = parseData(data1.toString());
print(tableData);
    int numColumns = 2;

    // Calculate number of rows
    int numRows = (tableData.length / numColumns).ceil();

    List<TableRow> tableRows = [];

    // Loop through the data and create rows and cells
    for (int i = 0; i < numRows; i++) {
      List<Widget> cells = [];
      for (int j = 0; j < numColumns; j++) {
        int index = i * numColumns + j;
        if (index < tableData.length) {
          cells.add(
            TableCell(
              child: InkWell(
                onTap: (){
                  print(tableData[index]);
                },
                child: Center(
                  child: Text(tableData[index]),
                ),
              ),
            ),
          );
        } else {
          // Add empty cell if data runs out
          cells.add(
            TableCell(
              child:
                  Container(), // You can add any widget you like for empty cells
            ),
          );
        }
      }
      tableRows.add(TableRow(children: cells));
    }
    print(tableData[0]);
    return Table(
      border: TableBorder.all(),
      children: tableRows,
    );
  }

}

