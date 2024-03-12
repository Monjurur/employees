import 'dart:convert';

import 'package:employees/database/db_service.dart';
import 'package:employees/pages/cameraPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:employees/database/database.dart' as database;


class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {

  List<String> employeeList = [];
  bool isLoading = false;
  late SharedPreferences sharedPreferences;
  late database.Database _db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _db = DatabaseService().db;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.downloading),onPressed: ()async{
         /* sharedPreferences = await SharedPreferences.getInstance();
        employeeList =  sharedPreferences.getStringList("User")!;*/
        var emp = _db.getAllEmployee();
print(emp);
        },),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Employee List"),
      ),
      body:
/*      Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            title:Text("Fahim",style: TextStyle(fontWeight: FontWeight.w600),) ,
            // subtitle: Text("${post["body"]}"),
          ),
        ),
      ),*/

       ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:  ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Image border
                  child: Image.asset(
                    'assets/images/person.jpg',fit: BoxFit.fill,
                  ),
                ),
                trailing: const Icon(Icons.ice_skating_rounded),
                title:const Text("Md.Monjurur Roshid",style: TextStyle(fontWeight: FontWeight.w600),) ,
                 subtitle: const Text("{post}"),
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CameraPage(),
              ),
            );
        },
        tooltip: 'Add Employees',
        child: const Icon(Icons.add),
      ),
    );
  }
}
