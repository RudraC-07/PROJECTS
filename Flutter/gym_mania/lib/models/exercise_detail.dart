class ExerciseDetail {
  final int? id;
  final int exerciseId;
  final String type;
  final String content;
  final int orderIndex;

  ExerciseDetail({
    this.id,
    required this.exerciseId,
    required this.type,
    required this.content,
    this.orderIndex = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exercise_id': exerciseId,
      'type': type,
      'content': content,
      'order_index': orderIndex,
    };
  }

  factory ExerciseDetail.fromMap(Map<String, dynamic> map) {
    return ExerciseDetail(
      id: map['id']?.toInt(),
      exerciseId: map['exercise_id']?.toInt() ?? 0,
      type: map['type'] ?? '',
      content: map['content'] ?? '',
      orderIndex: map['order_index']?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'ExerciseDetail{id: $id, exerciseId: $exerciseId, type: $type, content: $content, orderIndex: $orderIndex}';
  }
}
