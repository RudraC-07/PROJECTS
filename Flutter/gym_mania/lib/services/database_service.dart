import 'package:gym_mania/database/db_helper.dart';
import 'package:gym_mania/models/exercise.dart';
import 'package:gym_mania/models/exercise_detail.dart';
import 'package:gym_mania/models/category.dart';
import 'package:gym_mania/models/muscle_group.dart';
import 'package:gym_mania/models/routine.dart';
import 'package:gym_mania/models/routine_exercise.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final DbHelper _dbHelper = DbHelper();

  // Exercise Operations
  Future<List<Exercise>> getAllExercises() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Exercise');
    return List.generate(maps.length, (i) => Exercise.fromMap(maps[i]));
  }

  Future<List<Exercise>> getExercisesByCategory(int categoryId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Exercise',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return List.generate(maps.length, (i) => Exercise.fromMap(maps[i]));
  }

  Future<List<Exercise>> getExercisesByDifficulty(String difficulty) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Exercise',
      where: 'difficulty = ?',
      whereArgs: [difficulty],
    );
    return List.generate(maps.length, (i) => Exercise.fromMap(maps[i]));
  }

  Future<Exercise?> getExerciseById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Exercise',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Exercise.fromMap(maps.first);
    }
    return null;
  }

  // Category Operations
  Future<List<Category>> getAllCategories() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Category');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<Category?> getCategoryById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Category',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    }
    return null;
  }

  // Muscle Group Operations
  Future<List<MuscleGroup>> getAllMuscleGroups() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('MuscleGroup');
    return List.generate(maps.length, (i) => MuscleGroup.fromMap(maps[i]));
  }

  Future<MuscleGroup?> getMuscleGroupById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'MuscleGroup',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MuscleGroup.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Exercise>> getExercisesByMuscleGroup(int muscleGroupId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT e.*
      FROM Exercise e
      INNER JOIN ExerciseMuscleGroup emg ON e.id = emg.exercise_id
      WHERE emg.muscle_group_id = ?
      ORDER BY e.name ASC
    ''', [muscleGroupId]);
    return List.generate(maps.length, (i) => Exercise.fromMap(maps[i]));
  }

  Future<List<MuscleGroup>> getMuscleGroupsForExercise(int exerciseId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT mg.*
      FROM MuscleGroup mg
      INNER JOIN ExerciseMuscleGroup emg ON mg.id = emg.muscle_group_id
      WHERE emg.exercise_id = ?
      ORDER BY mg.name ASC
    ''', [exerciseId]);
    return List.generate(maps.length, (i) => MuscleGroup.fromMap(maps[i]));
  }

  // Statistics
  Future<int> getTotalExerciseCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM Exercise');
    return result.first['count'] as int;
  }

  Future<int> getTotalCategoryCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM Category');
    return result.first['count'] as int;
  }

  Future<int> getTotalMuscleGroupCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM MuscleGroup');
    return result.first['count'] as int;
  }

  Future<Map<String, int>> getExerciseCountByDifficulty() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT difficulty, COUNT(*) as count 
      FROM Exercise 
      WHERE difficulty IS NOT NULL 
      GROUP BY difficulty
    ''');
    
    Map<String, int> counts = {};
    for (var row in result) {
      counts[row['difficulty'] as String] = row['count'] as int;
    }
    return counts;
  }

  Future<Map<String, int>> getExerciseCountByCategory() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT c.name, COUNT(e.id) as count
      FROM Category c
      LEFT JOIN Exercise e ON c.id = e.category_id
      GROUP BY c.id, c.name
    ''');
    
    Map<String, int> counts = {};
    for (var row in result) {
      counts[row['name'] as String] = row['count'] as int;
    }
    return counts;
  }

  // Search functionality
  Future<List<Exercise>> searchExercises(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT DISTINCT e.*
      FROM Exercise e
      LEFT JOIN Category c ON e.category_id = c.id
      LEFT JOIN ExerciseMuscleGroup emg ON e.id = emg.exercise_id
      LEFT JOIN MuscleGroup mg ON emg.muscle_group_id = mg.id
      WHERE e.name LIKE ? 
         OR e.description LIKE ?
         OR c.name LIKE ?
         OR mg.name LIKE ?
      ORDER BY e.name ASC
    ''', ['%$query%', '%$query%', '%$query%', '%$query%']);
    return List.generate(maps.length, (i) => Exercise.fromMap(maps[i]));
  }

  Future<List<Exercise>> searchExercisesByNameOnly(String query) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Exercise',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Exercise.fromMap(maps[i]));
  }

  // Routine Operations
  Future<int> createRoutine(Routine routine) async {
    final db = await _dbHelper.database;
    return await db.insert('Routine', routine.toMap());
  }

  Future<List<Routine>> getAllRoutines() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Routine',
    );
    return List.generate(maps.length, (i) => Routine.fromMap(maps[i]));
  }

  Future<List<Routine>> getRoutinesByDay(String dayOfWeek) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Routine',
      where: 'day_of_week = ? AND is_active = 1',
      whereArgs: [dayOfWeek],
    );
    return List.generate(maps.length, (i) => Routine.fromMap(maps[i]));
  }

  Future<Routine?> getRoutineById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Routine',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Routine.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateRoutine(Routine routine) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Routine',
      routine.toMap(),
      where: 'id = ?',
      whereArgs: [routine.id],
    );
  }

  Future<int> deleteRoutine(int id) async {
    final db = await _dbHelper.database;
    // First delete associated routine exercises
    await db.delete(
      'RoutineExercise',
      where: 'routine_id = ?',
      whereArgs: [id],
    );
    // Then delete the routine
    return await db.delete(
      'Routine',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Routine Exercise Operations
  Future<int> addExerciseToRoutine(RoutineExercise routineExercise) async {
    final db = await _dbHelper.database;
    return await db.insert('RoutineExercise', routineExercise.toMap());
  }

  Future<List<RoutineExercise>> getRoutineExercises(int routineId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'RoutineExercise',
      where: 'routine_id = ?',
      whereArgs: [routineId],
      orderBy: 'order_index ASC',
    );
    return List.generate(maps.length, (i) => RoutineExercise.fromMap(maps[i]));
  }

  Future<List<Map<String, dynamic>>> getRoutineExercisesWithDetails(int routineId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        re.*,
        e.name as exercise_name,
        e.description as exercise_description,
        e.difficulty as exercise_difficulty,
        e.image as exercise_image
      FROM RoutineExercise re
      JOIN Exercise e ON re.exercise_id = e.id
      WHERE re.routine_id = ?
      ORDER BY re.order_index ASC
    ''', [routineId]);
    return maps;
  }

  Future<int> updateRoutineExercise(RoutineExercise routineExercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      'RoutineExercise',
      routineExercise.toMap(),
      where: 'id = ?',
      whereArgs: [routineExercise.id],
    );
  }

  Future<int> removeExerciseFromRoutine(int routineExerciseId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'RoutineExercise',
      where: 'id = ?',
      whereArgs: [routineExerciseId],
    );
  }

  Future<int> removeAllExercisesForRoutine(int routineId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'RoutineExercise',
      where: 'routine_id = ?',
      whereArgs: [routineId],
    );
  }

  Future<int> getTotalRoutineCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM Routine WHERE is_active = 1');
    return result.first['count'] as int;
  }

  Future<Map<String, int>> getRoutineCountByDay() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT day_of_week, COUNT(*) as count
      FROM Routine 
      WHERE is_active = 1
      GROUP BY day_of_week
    ''');
    
    Map<String, int> counts = {};
    for (var row in result) {
      counts[row['day_of_week'] as String] = row['count'] as int;
    }
    return counts;
  }

  // Exercise Detail Operations
  Future<List<ExerciseDetail>> getExerciseDetails(int exerciseId, String type) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ExerciseDetail',
      where: 'exercise_id = ? AND type = ?',
      whereArgs: [exerciseId, type],
      orderBy: 'order_index ASC',
    );
    return List.generate(maps.length, (i) => ExerciseDetail.fromMap(maps[i]));
  }

  Future<List<String>> getExerciseInstructions(int exerciseId) async {
    final details = await getExerciseDetails(exerciseId, 'instruction');
    return details.map((detail) => detail.content).toList();
  }

  Future<List<String>> getExerciseTips(int exerciseId) async {
    final details = await getExerciseDetails(exerciseId, 'tip');
    return details.map((detail) => detail.content).toList();
  }

  Future<List<String>> getExerciseEquipment(int exerciseId) async {
    final details = await getExerciseDetails(exerciseId, 'equipment');
    return details.map((detail) => detail.content).toList();
  }

  Future<int> insertExerciseDetail(ExerciseDetail exerciseDetail) async {
    final db = await _dbHelper.database;
    return await db.insert('ExerciseDetail', exerciseDetail.toMap());
  }

  // Initialize sample data if database is empty
  Future<void> initializeSampleDataIfEmpty() async {
    try {
      final exerciseCount = await getTotalExerciseCount();
      if (exerciseCount == 0) {
        await _dbHelper.insertSampleData();
      }
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }
}
