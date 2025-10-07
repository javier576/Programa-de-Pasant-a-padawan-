import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> initDB() async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), "auth_demo.db");

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            Name TEXT,
            Nacimiento TEXT,
            Telefono integer,
            Pais TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        """);
      },
    );
    return _db!;
  }

  static Future<int> registerUser(
    String email,
    String password,
    String name,
    String nacimiento,
    int telefono,
    String pais,
  ) async {
    final db = await initDB();
    return await db.insert("users", {
      "email": email,
      "password": password,
      "Name": name,
      "Nacimiento": nacimiento,
      "Telefono": telefono,
      "Pais": pais,
    });
  }

  static Future<Map<String, dynamic>?> loginUser(
    String email,
    String password,
  ) async {
    final db = await initDB();
    final res = await db.query(
      "users",
      where: "email = ? AND  password = ? ",
      whereArgs: [email, password],
    );
    return res.isNotEmpty ? res.first : null;
  }

  static Future<int> resetPassword(String email, String newPassword) async {
    final db = await initDB();
    return await db.update(
      "users",
      {"password": newPassword},
      where: "email = ?",
      whereArgs: [email],
    );
  }

  static Future<bool> emailExists(String email) async {
    final db = await initDB();
    final res = await db.query("users", where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty;
  }
}
