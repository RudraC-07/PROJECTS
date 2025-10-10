class RoutineExercise {
  final int? id;
  final int routineId;
  final int exerciseId;
  final int? sets;
  final int? reps;
  final int? duration;
  final int? restTime;
  final int orderIndex;

  RoutineExercise({
    this.id,
    required this.routineId,
    required this.exerciseId,
    this.sets,
    this.reps,
    this.duration,
    this.restTime,
    this.orderIndex = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'routine_id': routineId,
      'exercise_id': exerciseId,
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'rest_time': restTime,
      'order_index': orderIndex,
    };
  }

  factory RoutineExercise.fromMap(Map<String, dynamic> map) {
    return RoutineExercise(
      id: map['id'],
      routineId: map['routine_id'] ?? 0,
      exerciseId: map['exercise_id'] ?? 0,
      sets: map['sets'],
      reps: map['reps'],
      duration: map['duration'],
      restTime: map['rest_time'],
      orderIndex: map['order_index'] ?? 0,
    );
  }

  RoutineExercise copyWith({
    int? id,
    int? routineId,
    int? exerciseId,
    int? sets,
    int? reps,
    int? duration,
    int? restTime,
    int? orderIndex,
  }) {
    return RoutineExercise(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
      restTime: restTime ?? this.restTime,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
