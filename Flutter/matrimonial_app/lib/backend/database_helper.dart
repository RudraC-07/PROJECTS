import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _dbName = "heartlink.db";
  static const int _dbVersion = 1;
  static const String tableName = "users";

  static const String columnId = "id";
  static const String columnName = "name";
  static const String columnEmail = "email";
  static const String columnMobile = "mobile";
  static const String columnDob = "dob";
  static const String columnGender = "gender";
  static const String columnCity = "city";
  static const String columnHobbies = "hobbies";
  static const String columnPassword = "password";
  static const String columnFavorite = "favorite"; // 0 (false) or 1 (true)

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnEmail TEXT NOT NULL UNIQUE,
        $columnMobile TEXT NOT NULL UNIQUE,
        $columnDob TEXT NOT NULL,
        $columnGender TEXT NOT NULL,
        $columnCity TEXT NOT NULL,
        $columnHobbies TEXT,
        $columnPassword TEXT NOT NULL,
        $columnFavorite INTEGER DEFAULT 0
      )
    ''');
  }

  // Insert User
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert(tableName, user);
  }

  // Get All Users
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database db = await database;
    return await db.query(tableName);
  }

  // Update User
  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    return await db.update(
      tableName,
      user,
      where: '$columnId = ?',
      whereArgs: [user[columnId]], // Ensure that the map contains 'id'
    );
  }

  // Delete User
  Future<int> deleteUser(int id) async {
    Database db = await database;
    return await db.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  // Toggle Favorite Status
  Future<int> toggleFavorite(int id, bool currentStatus) async {
    final db = await database;
    int newStatus = currentStatus ? 0 : 1; // Toggle status

    return await db.update(
      tableName,
      {columnFavorite: newStatus},
      where: "$columnId = ?",
      whereArgs: [id],
    );
  }

  // Get Favorite Users
  Future<List<Map<String, dynamic>>> getFavoriteUsers() async {
    final db = await database;
    return await db.query(
      tableName,
      where: '$columnFavorite = ?',
      whereArgs: [1], // Fetch users where favorite = 1
    );
  }

  // Get User by ID
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> updateFavoriteStatus(int id, int favorite) async {
    final db = await database;
    await db.update(
      'users',
      {'favorite': favorite},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> fetchFavorites() async {
    final db = await database;
    return await db.query('users', where: 'favorite = ?', whereArgs: [1]);
  }


}
