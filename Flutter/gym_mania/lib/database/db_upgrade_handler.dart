import 'package:sqflite/sqflite.dart';
import 'exercice_detail_data.dart';

class DatabaseUpgradeHandler {
  Future<void> handleUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Add routine tables if upgrading to version 3
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Routine (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          day_of_week TEXT NOT NULL,
          is_active INTEGER DEFAULT 1
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS RoutineExercise (
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
    }

    if (oldVersion < 2) {
      await db.execute('drop table Exercise');
      await db.execute('''
        CREATE TABLE Exercise (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT,
          category_id INTEGER NOT NULL,
          difficulty TEXT,
          image TEXT,
          FOREIGN KEY (category_id) REFERENCES Category(id)
        )
      ''');
    }

    if (oldVersion < 5) {
      // Remove unwanted fields from RoutineExercise table
      // Create new table with only required fields
      await db.execute('''
        CREATE TABLE RoutineExercise_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          routine_id INTEGER NOT NULL,
          exercise_id INTEGER NOT NULL,
          order_index INTEGER DEFAULT 0,
          FOREIGN KEY (routine_id) REFERENCES Routine(id),
          FOREIGN KEY (exercise_id) REFERENCES Exercise(id)
        )
      ''');

      // Copy data from old table to new table (only required fields)
      await db.execute('''
        INSERT INTO RoutineExercise_new (id, routine_id, exercise_id, order_index)
        SELECT id, routine_id, exercise_id, order_index
        FROM RoutineExercise
      ''');

      // Drop old table
      await db.execute('DROP TABLE RoutineExercise');
      // Rename new table to original name
      await db.execute('ALTER TABLE RoutineExercise_new RENAME TO RoutineExercise');
    }

    if (oldVersion < 6) {
      // Remove description field from Routine table
      // Create new table without description field
      await db.execute('''
        CREATE TABLE Routine_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          day_of_week TEXT NOT NULL,
          is_active INTEGER DEFAULT 1
        )
      ''');

      // Copy data from old table to new table (without description)
      await db.execute('''
        INSERT INTO Routine_new (id, name, day_of_week, is_active)
        SELECT id, name, day_of_week, is_active
        FROM Routine
      ''');

      // Drop old table
      await db.execute('DROP TABLE Routine');
      // Rename new table to original name
      await db.execute('ALTER TABLE Routine_new RENAME TO Routine');
    }

    if (oldVersion < 7) {
      // Add back sets, reps, duration, rest_time fields to RoutineExercise table
      await db.execute('ALTER TABLE RoutineExercise ADD COLUMN sets INTEGER');
      await db.execute('ALTER TABLE RoutineExercise ADD COLUMN reps INTEGER');
      await db.execute('ALTER TABLE RoutineExercise ADD COLUMN duration INTEGER');
      await db.execute('ALTER TABLE RoutineExercise ADD COLUMN rest_time INTEGER');
    }

    if (oldVersion < 8) {
      // Ensure ExerciseMuscleGroup data is populated
      // Check if there's any data in ExerciseMuscleGroup table
      final muscleGroupMappings = await db.rawQuery('SELECT COUNT(*) as count FROM ExerciseMuscleGroup');
      if ((muscleGroupMappings.first['count'] as int) == 0) {
        // Insert the muscle group mappings
        await _insertMuscleGroupMappings(db);
      }
    }

    if (oldVersion < 9) {
      // Create ExerciseDetail table for instructions, tips, and equipment
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
      // Populate the ExerciseDetail table with default data
      final exerciseDetailData = ExerciseDetailData();
      await exerciseDetailData.insertExerciseDetails(db);
    }

    if (oldVersion < 10) {
      // Backfill ExerciseDetail if table exists but is empty
      final detailCount = await db.rawQuery('SELECT COUNT(*) as count FROM ExerciseDetail');
      if ((detailCount.first['count'] as int) == 0) {
        final exerciseDetailData = ExerciseDetailData();
        await exerciseDetailData.insertExerciseDetails(db);
      }
    }

    if (oldVersion < 11) {
      // Add cardio exercises (61-70) if they don't exist
      await _insertCardioExercises(db);
      await _insertCardioMuscleGroupMappings(db);
    }

    if (oldVersion < 12) {
      // Add exercise details for cardio exercises (61-70) if they don't exist
      await _insertCardioExerciseDetails(db);
    }
  }

  Future<void> _insertMuscleGroupMappings(Database db) async {
    // Chest exercises (Muscle Group ID 1 = Chest)
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 1, 'muscle_group_id': 1}); // Push Up - Chest
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 1, 'muscle_group_id': 3}); // Push Up - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 2, 'muscle_group_id': 1}); // Barbell Bench Press - Chest
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 2, 'muscle_group_id': 3}); // Barbell Bench Press - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 3, 'muscle_group_id': 1}); // Dumbbell Flyes - Chest
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 4, 'muscle_group_id': 1}); // Incline Push Up - Chest
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 4, 'muscle_group_id': 3}); // Incline Push Up - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 5, 'muscle_group_id': 1}); // Decline Bench Press - Chest
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 6, 'muscle_group_id': 1}); // Chest Dips - Chest
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 6, 'muscle_group_id': 3}); // Chest Dips - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 7, 'muscle_group_id': 1}); // Cable Crossover - Chest
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 8, 'muscle_group_id': 1}); // Machine Chest Press - Chest
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 9, 'muscle_group_id': 1}); // Plyometric Push Up - Chest
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 10, 'muscle_group_id': 1}); // Close-Grip Push Up - Chest
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 10, 'muscle_group_id': 3}); // Close-Grip Push Up - Arms

    // Leg exercises (Muscle Group ID 2 = Legs)
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 11, 'muscle_group_id': 2}); // Squat - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 12, 'muscle_group_id': 2}); // Lunges - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 13, 'muscle_group_id': 2}); // Leg Press Machine - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 14, 'muscle_group_id': 2}); // Bulgarian Split Squat - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 15, 'muscle_group_id': 2}); // Calf Raise - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 16, 'muscle_group_id': 2}); // Glute Bridge - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 17, 'muscle_group_id': 2}); // Hamstring Curl - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 18, 'muscle_group_id': 2}); // Step Up - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 19, 'muscle_group_id': 2}); // Wall Sit - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 20, 'muscle_group_id': 2}); // Sumo Squat - Legs

    // Arm exercises (Muscle Group ID 3 = Arms)
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 21, 'muscle_group_id': 3}); // Tricep Dips - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 22, 'muscle_group_id': 3}); // Bicep Curl - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 23, 'muscle_group_id': 3}); // Tricep Pushdown - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 24, 'muscle_group_id': 3}); // Hammer Curl - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 25, 'muscle_group_id': 3}); // Skullcrusher - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 26, 'muscle_group_id': 3}); // Cable Curl - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 27, 'muscle_group_id': 3}); // Concentration Curl - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 28, 'muscle_group_id': 3}); // Overhead Tricep Ext. - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 29, 'muscle_group_id': 3}); // EZ-Bar Curl - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 30, 'muscle_group_id': 3}); // Reverse Curl - Arms

    // Back exercises (Muscle Group ID 4 = Back)
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 31, 'muscle_group_id': 4}); // Pull Up - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 31, 'muscle_group_id': 3}); // Pull Up - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 32, 'muscle_group_id': 4}); // Lat Pulldown - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 33, 'muscle_group_id': 4}); // Seated Row - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 34, 'muscle_group_id': 4}); // Bent Over Row - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 35, 'muscle_group_id': 4}); // Deadlift - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 35, 'muscle_group_id': 2}); // Deadlift - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 36, 'muscle_group_id': 4}); // T-Bar Row - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 37, 'muscle_group_id': 4}); // Inverted Row - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 38, 'muscle_group_id': 4}); // Superman - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 39, 'muscle_group_id': 4}); // Resistance Band Row - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 40, 'muscle_group_id': 4}); // Single Arm Dumbbell Row - Back

    // Abs exercises (Muscle Group ID 5 = Abs)
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 41, 'muscle_group_id': 5}); // Crunch - Abs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 42, 'muscle_group_id': 5}); // Plank - Abs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 43, 'muscle_group_id': 5}); // Bicycle Crunch - Abs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 44, 'muscle_group_id': 5}); // Leg Raise - Abs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 45, 'muscle_group_id': 5}); // Russian Twist - Abs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 46, 'muscle_group_id': 5}); // Mountain Climber - Abs (also cardio)
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 47, 'muscle_group_id': 5}); // V-Up - Abs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 48, 'muscle_group_id': 5}); // Flutter Kicks - Abs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 49, 'muscle_group_id': 5}); // Reverse Crunch - Abs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 50, 'muscle_group_id': 5}); // Hanging Knee Raise - Abs

    // Shoulder exercises (Muscle Group ID 6 = Shoulders)
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 51, 'muscle_group_id': 6}); // Shoulder Press - Shoulders
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 52, 'muscle_group_id': 6}); // Dumbbell Lateral Raise - Shoulders
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 53, 'muscle_group_id': 6}); // Front Raise - Shoulders
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 54, 'muscle_group_id': 6}); // Arnold Press - Shoulders
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 55, 'muscle_group_id': 6}); // Rear Delt Fly - Shoulders
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 56, 'muscle_group_id': 6}); // Upright Row - Shoulders
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 57, 'muscle_group_id': 6}); // Face Pull - Shoulders
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 58, 'muscle_group_id': 6}); // Push Press - Shoulders
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 59, 'muscle_group_id': 6}); // Pike Push Up - Shoulders
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 60, 'muscle_group_id': 6}); // Seated Barbell Press - Shoulders
  }

  Future<void> _insertCardioExercises(Database db) async {
    // Check if cardio exercises already exist
    final cardioCount = await db.rawQuery('SELECT COUNT(*) as count FROM Exercise WHERE id >= 61 AND id <= 70');
    if ((cardioCount.first['count'] as int) > 0) {
      return; // Cardio exercises already exist
    }

    // Insert Cardio Exercises
    await db.insert('Exercise', {
      'id': 61,
      'name': 'Running',
      'description': 'Outdoor or treadmill running for cardiovascular endurance',
      'category_id': 2,
      'difficulty': 'Beginner',
      'image': 'assets/images/cardio.png'
    });
    await db.insert('Exercise', {
      'id': 62,
      'name': 'Cycling',
      'description': 'Stationary bike or outdoor cycling for leg cardio',
      'category_id': 2,
      'difficulty': 'Beginner',
      'image': 'assets/images/cardio.png'
    });
    await db.insert('Exercise', {
      'id': 63,
      'name': 'Jump Rope',
      'description': 'Skipping rope for coordination and cardio',
      'category_id': 2,
      'difficulty': 'Intermediate',
      'image': 'assets/images/cardio.png'
    });
    await db.insert('Exercise', {
      'id': 64,
      'name': 'Elliptical',
      'description': 'Low-impact cardio machine for full body workout',
      'category_id': 2,
      'difficulty': 'Beginner',
      'image': 'assets/images/cardio.png'
    });
    await db.insert('Exercise', {
      'id': 65,
      'name': 'Rowing',
      'description': 'Rowing machine for upper body and cardio',
      'category_id': 2,
      'difficulty': 'Intermediate',
      'image': 'assets/images/cardio.png'
    });
    await db.insert('Exercise', {
      'id': 66,
      'name': 'Burpees',
      'description': 'Full body explosive movement for high intensity cardio',
      'category_id': 2,
      'difficulty': 'Advanced',
      'image': 'assets/images/cardio.png'
    });
    await db.insert('Exercise', {
      'id': 67,
      'name': 'High Knees',
      'description': 'Running in place with high knee lifts',
      'category_id': 2,
      'difficulty': 'Beginner',
      'image': 'assets/images/cardio.png'
    });
    await db.insert('Exercise', {
      'id': 68,
      'name': 'Jumping Jacks',
      'description': 'Classic cardio exercise with jumping and arm movement',
      'category_id': 2,
      'difficulty': 'Beginner',
      'image': 'assets/images/cardio.png'
    });
    await db.insert('Exercise', {
      'id': 69,
      'name': 'Stair Climbing',
      'description': 'Climbing stairs or using stair machine for leg cardio',
      'category_id': 2,
      'difficulty': 'Intermediate',
      'image': 'assets/images/cardio.png'
    });
    await db.insert('Exercise', {
      'id': 70,
      'name': 'Swimming',
      'description': 'Full body low-impact cardio exercise',
      'category_id': 2,
      'difficulty': 'Intermediate',
      'image': 'assets/images/cardio.png'
    });
  }

  Future<void> _insertCardioMuscleGroupMappings(Database db) async {
    // Cardio exercises muscle group relationships
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 61, 'muscle_group_id': 2}); // Running - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 62, 'muscle_group_id': 2}); // Cycling - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 63, 'muscle_group_id': 2}); // Jump Rope - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 63, 'muscle_group_id': 3}); // Jump Rope - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 64, 'muscle_group_id': 2}); // Elliptical - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 64, 'muscle_group_id': 3}); // Elliptical - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 65, 'muscle_group_id': 2}); // Rowing - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 65, 'muscle_group_id': 3}); // Rowing - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 65, 'muscle_group_id': 4}); // Rowing - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 66, 'muscle_group_id': 2}); // Burpees - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 66, 'muscle_group_id': 3}); // Burpees - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 66, 'muscle_group_id': 5}); // Burpees - Abs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 67, 'muscle_group_id': 2}); // High Knees - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 67, 'muscle_group_id': 5}); // High Knees - Abs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 68, 'muscle_group_id': 2}); // Jumping Jacks - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 68, 'muscle_group_id': 3}); // Jumping Jacks - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 68, 'muscle_group_id': 6}); // Jumping Jacks - Shoulders
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 69, 'muscle_group_id': 2}); // Stair Climbing - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 70, 'muscle_group_id': 2}); // Swimming - Legs
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 70, 'muscle_group_id': 3}); // Swimming - Arms
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 70, 'muscle_group_id': 4}); // Swimming - Back
    await db.insert('ExerciseMuscleGroup', {'exercise_id': 70, 'muscle_group_id': 6}); // Swimming - Shoulders
  }

  Future<void> _insertCardioExerciseDetails(Database db) async {
    // Instructions for cardio exercises
    final Map<int, List<String>> cardioInstructions = {
      61: [ // Running
        'Start with a proper warm-up and stretching.',
        'Maintain good posture with chest up and shoulders relaxed.',
        'Land mid-foot with each step to reduce impact.',
        'Keep your arms at 90-degree angles and swing naturally.',
        'Breathe rhythmically and maintain a steady pace.',
      ],
      62: [ // Cycling
        'Adjust seat height so your leg is almost straight at bottom of pedal stroke.',
        'Keep your back straight and shoulders relaxed.',
        'Maintain a steady cadence of 80-100 RPM.',
        'Use proper cycling shoes for better power transfer.',
        'Stay hydrated and take breaks as needed.',
      ],
      63: [ // Jump Rope
        'Hold handles at hip level with elbows close to body.',
        'Jump on the balls of your feet with slight knee bend.',
        'Keep jumps low and controlled, about 1-2 inches off ground.',
        'Maintain rhythm and timing with rope rotation.',
        'Start with basic jumps before trying advanced moves.',
      ],
      64: [ // Elliptical
        'Stand tall with shoulders back and core engaged.',
        'Keep your feet flat on the foot pedals.',
        'Use both forward and backward motion for variety.',
        'Don\'t lean on the handles - use them for balance only.',
        'Maintain a steady pace and resistance level.',
      ],
      65: [ // Rowing
        'Start with legs extended, arms straight, leaning forward.',
        'Drive back with legs first, then lean back, then pull arms.',
        'Keep your back straight and core engaged throughout.',
        'Return to starting position in reverse order.',
        'Focus on smooth, fluid motion rather than speed.',
      ],
      66: [ // Burpees
        'Start standing, then drop into a squat position.',
        'Place hands on ground and kick feet back to plank position.',
        'Perform a push-up (optional), then jump feet back to squat.',
        'Explosively jump up with arms overhead.',
        'Land softly and immediately go into next repetition.',
      ],
      67: [ // High Knees
        'Stand in place with feet hip-width apart.',
        'Run in place, bringing knees up to waist level.',
        'Pump your arms as if running normally.',
        'Stay on the balls of your feet.',
        'Maintain good posture and engage your core.',
      ],
      68: [ // Jumping Jacks
        'Start standing with feet together and arms at sides.',
        'Jump feet apart while raising arms overhead.',
        'Jump back to starting position with arms down.',
        'Keep movements controlled and rhythmic.',
        'Land softly to reduce impact on joints.',
      ],
      69: [ // Stair Climbing
        'Step up with your whole foot, not just toes.',
        'Keep your back straight and core engaged.',
        'Use handrails for balance if needed, but don\'t rely on them.',
        'Maintain a steady pace and rhythm.',
        'Take breaks as needed to maintain proper form.',
      ],
      70: [ // Swimming
        'Start with proper breathing technique and stroke form.',
        'Keep your body horizontal and streamlined in the water.',
        'Use your core to maintain body position.',
        'Coordinate arm and leg movements for efficient swimming.',
        'Start with shorter distances and build endurance gradually.',
      ],
    };

    // Tips for cardio exercises
    final Map<int, List<String>> cardioTips = {
      61: [ // Running
        'Start with shorter distances and gradually increase',
        'Invest in good running shoes for proper support',
        'Listen to your body and don\'t push through pain',
        'Stay hydrated and fuel properly before and after',
      ],
      62: [ // Cycling
        'Adjust bike settings for proper fit and comfort',
        'Start with shorter sessions and build endurance',
        'Use proper cycling form to prevent injury',
        'Vary your intensity with intervals and steady state',
      ],
      63: [ // Jump Rope
        'Start with basic jumps before trying advanced moves',
        'Use proper rope length - handles should reach armpits',
        'Jump on a forgiving surface to reduce impact',
        'Focus on rhythm and timing rather than speed initially',
      ],
      64: [ // Elliptical
        'Don\'t lean on the handles - use them for balance only',
        'Vary your resistance and incline for different workouts',
        'Keep your feet flat on the pedals throughout',
        'Use both forward and backward motion for variety',
      ],
      65: [ // Rowing
        'Focus on proper form over speed or distance',
        'Use your legs for power, not just your arms',
        'Keep your back straight and core engaged',
        'Start with shorter sessions to build endurance',
      ],
      66: [ // Burpees
        'Start with modified versions if needed',
        'Focus on form and control over speed',
        'Take breaks between sets to maintain quality',
        'Land softly to protect your joints',
      ],
      67: [ // High Knees
        'Keep your core engaged throughout the movement',
        'Stay on the balls of your feet',
        'Maintain good posture and don\'t lean back',
        'Start with slower pace and increase speed gradually',
      ],
      68: [ // Jumping Jacks
        'Land softly to reduce impact on joints',
        'Keep movements controlled and rhythmic',
        'Maintain good posture throughout',
        'Start with slower pace and increase gradually',
      ],
      69: [ // Stair Climbing
        'Use proper footwear with good support',
        'Take one step at a time initially',
        'Keep your back straight and core engaged',
        'Use handrails for balance but don\'t rely on them',
      ],
      70: [ // Swimming
        'Start with proper breathing technique',
        'Take swimming lessons if you\'re a beginner',
        'Start with shorter distances and build up',
        'Use different strokes to work different muscle groups',
      ],
    };

    // Equipment for cardio exercises
    final Map<int, List<String>> cardioEquipment = {
      61: ['Running Shoes', 'Treadmill (Optional)'], // Running
      62: ['Stationary Bike', 'Cycling Shoes (Optional)'], // Cycling
      63: ['Jump Rope'], // Jump Rope
      64: ['Elliptical Machine'], // Elliptical
      65: ['Rowing Machine'], // Rowing
      66: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Burpees
      67: ['None (Bodyweight)'], // High Knees
      68: ['None (Bodyweight)'], // Jumping Jacks
      69: ['Stair Machine', 'Stairs'], // Stair Climbing
      70: ['Swimming Pool', 'Swimsuit'], // Swimming
    };

    // Insert instructions
    for (final exerciseId in cardioInstructions.keys) {
      final instructions = cardioInstructions[exerciseId]!;
      for (int i = 0; i < instructions.length; i++) {
        await db.insert('ExerciseDetail', {
          'exercise_id': exerciseId,
          'type': 'instruction',
          'content': instructions[i],
          'order_index': i,
        });
      }
    }

    // Insert tips
    for (final exerciseId in cardioTips.keys) {
      final tips = cardioTips[exerciseId]!;
      for (int i = 0; i < tips.length; i++) {
        await db.insert('ExerciseDetail', {
          'exercise_id': exerciseId,
          'type': 'tip',
          'content': tips[i],
          'order_index': i,
        });
      }
    }

    // Insert equipment
    for (final exerciseId in cardioEquipment.keys) {
      final equipment = cardioEquipment[exerciseId]!;
      for (int i = 0; i < equipment.length; i++) {
        await db.insert('ExerciseDetail', {
          'exercise_id': exerciseId,
          'type': 'equipment',
          'content': equipment[i],
          'order_index': i,
        });
      }
    }
  }
}
