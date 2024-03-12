import 'package:employees/database/database.dart';
import 'package:employees/database/database/mobile.dart';


class DatabaseService {
  static final DatabaseService _instance = DatabaseService.internal();
  factory DatabaseService() => _instance;

  Database? _db;

  DatabaseService.internal();

  Database get db {
    if (_db != null) {
      return _db!;
    }
    _db = constructDb();
    return _db!;
  }
}
