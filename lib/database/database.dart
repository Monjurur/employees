

import 'dart:convert';
import 'dart:developer' as d;
import 'package:drift/drift.dart';
import 'package:employees/model/employee_model.dart';

part 'database.g.dart';

class Employees extends Table {
  IntColumn get id => integer().nullable()();
  TextColumn get employeeId => text().nullable()();
  TextColumn get firstName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get photo => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get department => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get createdAt => integer().nullable()();
  IntColumn get lastModified => integer().nullable()();

  TextColumn get fullObject => text().nullable()();

  @override
  Set<Column> get primaryKey => {employeeId};
}


/*abstract class EmployeeView extends View {
   Employees get employees ;
   @override
  Query as() => select([
    employees.firstName
   ]).from(employees);
}*/


/*@DriftDatabase(tables:[
  Employees
], views: [
  EmployeeView
],)*/

@DriftDatabase(tables: [
  Employees,
/*  EmployeeWithPermissions,
  Stocks,
  Customers,
  Banks,
  Devices,
  Auths,
  AllDevices,
  Orders,
  HoldOrders,
  Tenders,
  Deposits,
  RoundOffs,
  SessionLedger,
  TillOrders,
  RemovedItems,
  SharedPrefs*/
])

class Database extends _$Database{
  Database(QueryExecutor e): super(e);

  @override
   int get schemaVersion =>1;

  Future<int> saveEmployee(Employee employee) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      await (delete(employees)..where((tbl) => tbl.employeeId.equals(employee.employeeId??''))).go();
      var res = await into(employees).insertOnConflictUpdate(employee);

      // List<Employee> employeeList = [];
      // List<EmployeeModel> employeeModelList = [];
      // if(res >= 0){
      //   employeeModelList = await getAllEmployee();
      //   if(employeeModelList.isNotEmpty){
      //     for (var element in employeeModelList) {
      //       employeeList.add(Employee.fromJson(element.toDBJson()));
      //     }
      //   }
      //   // prefs.setString('employeeList', jsonEncode(employeeList));
      // }

      return res;
    } catch (e) {
      d.log("Error[Database::saveEmployee]:", error: e);
      return 0;
    }
  }
/*  Future<List<Employee>> getEmployee() async {
    var data = await select(employees).get();
    if (data.isNotEmpty) {
      return List<Employee>.from(
          data.map((item) => Employee().fromJson(jsonDecode(item.full))));
    } else {
      return [];
    }
  }*/


  Future<int> updateEmployee(Employee employee) async {
    try {
      var res = await update(employees).replace(employee);
      return res ? 1 : 0;
    } catch (e) {
      d.log("[Error::Database::updateEmployee]:", error: e);
      return 0;
    }
  }

  Future<List<EmployeeModel>> getAllEmployee() async {
    var data = await (select(employees)
      ..orderBy([
            (i) => OrderingTerm(
            expression: i.lastModified, mode: OrderingMode.desc)
      ]))
        .get();

    if (data.isNotEmpty) {
      return List<EmployeeModel>.from(data
          .map((item) => EmployeeModel.fromJson(jsonDecode(item.fullObject!))));
    } else {
      return [];
    }
  }
}