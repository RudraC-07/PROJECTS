import 'package:sqflite/sqflite.dart';

class SampleDataInserter {
  Future insertExerciseData(Database db) async {
    final categoryCount = await db.rawQuery('SELECT COUNT(*) as count FROM Category');
    if ((categoryCount.first['count'] as int) > 0) {
      return;
    }

    // Insert Categories
    await db.insert('Category', {'id': 1, 'name': 'Strength', 'image': 'assets/images/strength.png'});
    await db.insert('Category', {'id': 2, 'name': 'Cardio', 'image': 'assets/images/cardio.png'});
    await db.insert('Category', {'id': 3, 'name': 'Abs', 'image': 'assets/images/abs.png'});

    // Insert Muscle Groups
    await db.insert('MuscleGroup', {'id': 1, 'name': 'Chest', 'image': 'assets/images/chest.png'});
    await db.insert('MuscleGroup', {'id': 2, 'name': 'Legs', 'image': 'assets/images/legs.png'});
    await db.insert('MuscleGroup', {'id': 3, 'name': 'Arms', 'image': 'assets/images/arms.png'});
    await db.insert('MuscleGroup', {'id': 4, 'name': 'Back', 'image': 'assets/images/back.png'});
    await db.insert('MuscleGroup', {'id': 5, 'name': 'Abs', 'image': 'assets/images/abs_m.png'});
    await db.insert('MuscleGroup', {'id': 6, 'name': 'Shoulders', 'image': 'assets/images/shoulders.png'});

    // Insert Exercises
    await db.insert('Exercise', {
      'id': 1,
      'name': 'Push Up',
      'description': 'Bodyweight exercise for chest',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/pushup.png'
    });
    await db.insert('Exercise', {
      'id': 2,
      'name': 'Barbell Bench Press',
      'description': 'Barbell exercise for upper body',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/benchpress.png'
    });
    await db.insert('Exercise', {
      'id': 3,
      'name': 'Dumbbell Flyes',
      'description': 'Chest isolation with dumbbells',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 4,
      'name': 'Incline Push Up',
      'description': 'Elevated push up for upper chest',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 5,
      'name': 'Decline Bench Press',
      'description': 'Lower chest barbell press',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 6,
      'name': 'Chest Dips',
      'description': 'Parallel bar dips for chest',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 7,
      'name': 'Cable Crossover',
      'description': 'Isolation with cables',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 8,
      'name': 'Machine Chest Press',
      'description': 'Seated machine press for chest',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 9,
      'name': 'Plyometric Push Up',
      'description': 'Explosive push up for power',
      'category_id': 1,
      'difficulty': 'Advanced',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 10,
      'name': 'Close-Grip Push Up',
      'description': 'Push up emphasizing triceps',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 11,
      'name': 'Squat',
      'description': 'Classic strength lower body',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 12,
      'name': 'Lunges',
      'description': 'Single-leg lower body',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 13,
      'name': 'Leg Press Machine',
      'description': 'Leg compound with machine',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 14,
      'name': 'Bulgarian Split Squat',
      'description': 'Unilateral leg strength',
      'category_id': 1,
      'difficulty': 'Advanced',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 15,
      'name': 'Calf Raise',
      'description': 'Raise heels for calf muscles',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 16,
      'name': 'Glute Bridge',
      'description': 'Hip/glute strength on ground',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 17,
      'name': 'Hamstring Curl',
      'description': 'Machine curl for back thigh',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 18,
      'name': 'Step Up',
      'description': 'Step onto bench for leg power',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 19,
      'name': 'Wall Sit',
      'description': 'Isometric leg strength',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 20,
      'name': 'Sumo Squat',
      'description': 'Wide stance squat for inner legs',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 21,
      'name': 'Tricep Dips',
      'description': 'Bodyweight dips for triceps',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 22,
      'name': 'Bicep Curl',
      'description': 'Dumbbell curl for biceps',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 23,
      'name': 'Tricep Pushdown',
      'description': 'Cable pushdown for triceps',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 24,
      'name': 'Hammer Curl',
      'description': 'Dumbbell curl with neutral grip',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 25,
      'name': 'Skullcrusher',
      'description': 'Lying EZ-bar triceps extension',
      'category_id': 1,
      'difficulty': 'Advanced',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 26,
      'name': 'Cable Curl',
      'description': 'Biceps cable isolation',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 27,
      'name': 'Concentration Curl',
      'description': 'Seated curl for bicep peak',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 28,
      'name': 'Overhead Tricep Ext.',
      'description': 'Dumbbell extension overhead',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 29,
      'name': 'EZ-Bar Curl',
      'description': 'Barbell curl for arms',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 30,
      'name': 'Reverse Curl',
      'description': 'Dumbbell/bar curl, palms down',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 31,
      'name': ' Pull Up',
      'description': 'Bodyweight back strength',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 32,
      'name': 'Lat Pulldown',
      'description': 'Machine pulldown for back',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 33,
      'name': 'Seated Row',
      'description': 'Row movement for middle back',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 34,
      'name': 'Bent Over Row',
      'description': 'Free weight row for lats/back',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 35,
      'name': 'Deadlift',
      'description': 'Full body strength with weight',
      'category_id': 1,
      'difficulty': 'Advanced',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 36,
      'name': 'T-Bar Row',
      'description': 'Compound rowing movement',
      'category_id': 1,
      'difficulty': 'Advanced',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 37,
      'name': 'Inverted Row',
      'description': 'Bodyweight row under bar',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 38,
      'name': 'Superman',
      'description': 'Prone back extension',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 39,
      'name': 'Resistance Band Row',
      'description': 'Band pulls for back',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 40,
      'name': 'Single Arm Dumbbell Row',
      'description': 'Dumbbell unilateral row',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 41,
      'name': 'Crunch',
      'description': 'Floor ab contraction',
      'category_id': 3,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 42,
      'name': 'Plank',
      'description': 'Isometric core hold',
      'category_id': 3,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 43,
      'name': 'Bicycle Crunch',
      'description': 'Alternating elbow-knee on floor',
      'category_id': 3,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 44,
      'name': 'Leg Raise',
      'description': 'Supine hip flexion',
      'category_id': 3,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 45,
      'name': 'Russian Twist',
      'description': 'Seated rotation for obliques',
      'category_id': 3,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 46,
      'name': 'Mountain Climber',
      'description': 'Dynamic plank/knee drive',
      'category_id': 2,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 47,
      'name': 'V-Up',
      'description': 'Floor pike for abs',
      'category_id': 3,
      'difficulty': 'Advanced',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 48,
      'name': 'Flutter Kicks',
      'description': 'Supine alternating leg raise',
      'category_id': 3,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 49,
      'name': 'Reverse Crunch',
      'description': 'Rolling pelvis for lower abs',
      'category_id': 3,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 50,
      'name': 'Hanging Knee Raise',
      'description': 'Hanging hip flexion',
      'category_id': 3,
      'difficulty': 'Advanced',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 51,
      'name': 'Shoulder Press',
      'description': 'Dumbbell overhead press',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 52,
      'name': 'Dumbbell Lateral Raise',
      'description': 'Lateral shoulder strength',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 53,
      'name': 'Front Raise',
      'description': 'Dumbbell anterior raise',
      'category_id': 1,
      'difficulty': 'Beginner',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 54,
      'name': 'Arnold Press',
      'description': 'Rotational overhead press',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 55,
      'name': 'Rear Delt Fly',
      'description': 'Dumbbell rear shoulder isolation',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 56,
      'name': 'Upright Row',
      'description': 'Barbell vertical lift',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 57,
      'name': 'Face Pull',
      'description': 'Band/cable pull for rear delts',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 58,
      'name': 'Push Press',
      'description': 'Power overhead press',
      'category_id': 1,
      'difficulty': 'Advanced',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 59,
      'name': 'Pike Push Up',
      'description': 'Shoulder bodyweight press',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });
    await db.insert('Exercise', {
      'id': 60,
      'name': 'Seated Barbell Press',
      'description': 'Overhead barbell press seated',
      'category_id': 1,
      'difficulty': 'Intermediate',
      'image': 'assets/images/squat.png'
    });

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

    // Insert ExerciseMuscleGroup relationships
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
}
