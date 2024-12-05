import 'package:assignment_2_offline_capabilities_with_local_storage/models/users_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../utils/constants/table_col_name_constants.dart';

class DBHelper {
  final createTableUser = '''CREATE TABLE $tableUser(
  $tblUserColId INTEGER PRIMARY KEY,
  $tblUserColName TEXT,
  $tblUserColUsername TEXT,
  $tblUserColEmail TEXT,
  $tblUserColPhone TEXT,
  $tblUserColWebsite TEXT)''';

  Future<Database> _open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = path.join(rootPath, 'user_db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(createTableUser);
      },
    );
  }

  /// -- Insert users method
  Future<void> insertUsers(UserModel user) async {
    final db = await _open();
    await db.insert(tableUser, user.toMap());
  }

  /// -- Fetch all Users method
  Future<List<UserModel>> getUsers() async {
    final db = await _open();
    final mapList = await db.query(tableUser);
    return List.generate(
        mapList.length, (index) => UserModel.fromMap(mapList[index]));
  }

  /// -- delete table method
  Future<void> clearCache() async {
    final db = await _open();
    await db.delete(tableUser);
  }
}
