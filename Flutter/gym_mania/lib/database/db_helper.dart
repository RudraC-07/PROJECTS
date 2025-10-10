import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_upgrade_handler.dart';
import 'exercice_detail_data.dart';
import 'exercise_data.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gym_mania.db');

    return await openDatabase(
      path,
      version: 12,
      onCreate: _onCreate,
      onUpgrade: (db, old, newV) async {
        final upgradeHandler = DatabaseUpgradeHandler();
        await upgradeHandler.handleUpgrade(db, old, newV);
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create tables
    await db.execute('''
      CREATE TABLE Category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE MuscleGroup (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category_id INTEGER NOT NULL,
        difficulty TEXT,
        image TEXT,
        FOREIGN KEY (category_id) REFERENCES Category(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ExerciseMuscleGroup (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_id INTEGER NOT NULL,
        muscle_group_id INTEGER NOT NULL,
        FOREIGN KEY (exercise_id) REFERENCES Exercise(id),
        FOREIGN KEY (muscle_group_id) REFERENCES MuscleGroup(id),
        UNIQUE(exercise_id, muscle_group_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Routine (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        day_of_week TEXT NOT NULL,
        is_active INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE RoutineExercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        routine_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        sets INTEGER,
        reps INTEGER,
        duration INTEGER,
        rest_time INTEGER,
        order_index INTEGER DEFAULT 0,
        FOREIGN KEY (routine_id) REFERENCES Routine(id),
        FOREIGN KEY (exercise_id) REFERENCES Exercise(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE ExerciseDetail (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        content TEXT NOT NULL,
        order_index INTEGER DEFAULT 0,
        FOREIGN KEY (exercise_id) REFERENCES Exercise(id)
      )
    ''');

    // Insert sample data right after tables creation
    final sampleDataInserter = SampleDataInserter();
    await sampleDataInserter.insertExerciseData(db);

    // Seed details after exercises are present
    final exerciseDetailData = ExerciseDetailData();
    await exerciseDetailData.insertExerciseDetails(db);
  }

  // Public method for manual data insertion if needed
  Future insertSampleData([Database? dbInstance]) async {
    final db = dbInstance ?? await database;
    final sampleDataInserter = SampleDataInserter();
    await sampleDataInserter.insertExerciseData(db);
  }
}
