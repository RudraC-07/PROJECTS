class Routine {
  final int? id;
  final String name;
  final String dayOfWeek; // Monday, Tuesday, etc.
  final bool isActive;

  Routine({
    this.id,
    required this.name,
    required this.dayOfWeek,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'day_of_week': dayOfWeek,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Routine.fromMap(Map<String, dynamic> map) {
    return Routine(
      id: map['id'],
      name: map['name'] ?? '',
      dayOfWeek: map['day_of_week'] ?? '',
      isActive: (map['is_active'] ?? 1) == 1,
    );
  }

  Routine copyWith({
    int? id,
    String? name,
    String? dayOfWeek,
    bool? isActive,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isActive: isActive ?? this.isActive,
    );
  }
}
