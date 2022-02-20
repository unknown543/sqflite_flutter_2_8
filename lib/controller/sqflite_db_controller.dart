import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../di.dart';
import '../model/test_data.model.dart';
import '../model/user.dart';
import '../screen/users_screen.dart';

class SqfLiteDbController {
  static const userDb = "usersDb.db";
  static const userTable = "user";
  static const userDbVersion = 1;
  static const userId = "id";
  static const userName = "username";
  static const email = "email";
  static const phone = "phone";
  static const password = "password";
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  Future initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, userDb);
    return await openDatabase(
      path,
      version: userDbVersion,
      onCreate: _createUserTable,
    );
  }

  Future _createUserTable(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $userTable (
        $userId INTEGER PRIMARY KEY AUTOINCREMENT,
        $userName TEXT NOT NULL,
        $email TEXT NOT NULL,
        $phone TEXT NOT NULL,
        $password TEXT NOT NULL
        )''');
    await db.execute('''
        CREATE TABLE test (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT NOT NULL
        )''');
  }

  Future<void> insertUser(User user, BuildContext context) async {
    try {
      Database db = await locator<SqfLiteDbController>().database;
      List<Map<String, dynamic>> list =
          await db.query(userTable, where: '$email=?', whereArgs: [user.email]);
      if (list.isNotEmpty) {
        showErrorSnackBar(context, "Email Id already exists");
      } else {
        await db.insert(userTable, user.toJson());
        showSuccessSnackBar(context, "User Registered Successfully");
        Navigator.pop(context);
      }
    } catch (e) {
      showErrorSnackBar(context, "Something went wrong");
    }
  }

  Future<void> insertTestDetail(BuildContext context) async {
    try {
      Database db = await locator<SqfLiteDbController>().database;
      var map = {
        "userId": 1,
        "id": 1,
        "title":
            "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
        "body":
            "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
        "users": [
          {
            "id": 1,
            "name": "Leanne Graham",
            "username": "Bret",
            "email": "Sincere@april.biz"
          }
        ]
      };
      var temp = <String, dynamic>{};
      temp["data"] = jsonEncode(map);
      await db.insert("test", temp);
      showSuccessSnackBar(context, "Success");
      fetchTest();
    } catch (e) {
      showErrorSnackBar(context, "Something went wrong");
    }
  }

  Future<void> fetchTest() async {
    try {
      Database database = await locator<SqfLiteDbController>().database;
      List<TestData> _list = <TestData>[];
      var user = await database.query("test");
      for (int i = 0; i < user.length; i++) {
        _list.add(TestData.fromJson(user[i]));
      }
      print(jsonEncode(_list[0].toJson()));
    } catch (e) {}
  }

  Future<bool> checkUserExists(String emailId, BuildContext context) async {
    try {
      Database db = await locator<SqfLiteDbController>().database;
      List<Map<String, dynamic>> list =
          await db.query(userTable, where: '$email=?', whereArgs: [emailId]);
      return list.isNotEmpty;
    } catch (e) {
      showErrorSnackBar(context, "Something went wrong");
      return false;
    }
  }

  Future<void> logInUser(
      String emailId, String pwd, BuildContext context) async {
    try {
      Database db = await locator<SqfLiteDbController>().database;
      List<Map<String, dynamic>> list = await db.query(userTable,
          where: '$email=? and $password=?', whereArgs: [emailId, pwd]);

      if (!(await checkUserExists(emailId, context))) {
        showErrorSnackBar(context, "email id not exists");
        return;
      }
      if (list.isNotEmpty) {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const UsersListScreen()));
      } else {
        showErrorSnackBar(context, "email id and password not match");
      }
    } catch (e) {
      showErrorSnackBar(context, "Something went wrong");
    }
  }

  Future<void> updatePassword(
      String emailId, String pwd, BuildContext context) async {
    try {
      Database db = await locator<SqfLiteDbController>().database;
      List<Map<String, dynamic>> users = await db.query(
        userTable,
        where: '$email=?',
        whereArgs: [emailId],
      );
      User user = User.fromJson(Map.from(users[0]));
      user.password = pwd;
      int list = await db.update(userTable, user.toJson(),
          where: '$email=?', whereArgs: [emailId]);
      if (list != -1) {
        showSuccessSnackBar(context, "password updated successfully");
        Navigator.pop(context);
      }
    } catch (e) {
      showErrorSnackBar(context, "Something went wrong");
    }
  }

  Future<List<User>> fetchAllUser() async {
    try {
      Database database = await locator<SqfLiteDbController>().database;
      List<User> _list = <User>[];
      var user = await database.query(userTable);
      for (int i = 0; i < user.length; i++) {
        _list.add(User.fromJson(user[i]));
      }
      return _list;
    } catch (e) {
      return [];
    }
  }
}

void showErrorSnackBar(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.hideCurrentSnackBar();
  scaffold.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.hideCurrentSnackBar();
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
    ),
  );
}
