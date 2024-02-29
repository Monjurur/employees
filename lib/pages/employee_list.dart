import 'package:employees/model/employee_model.dart';
import 'package:employees/pages/cameraPage.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {

  List<EmployeeModel> employeeList = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
