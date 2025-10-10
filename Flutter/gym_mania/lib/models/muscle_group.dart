class MuscleGroup {
  final int? id;
  final String name;
  final String? image;

  MuscleGroup({
    this.id,
    required this.name,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory MuscleGroup.fromMap(Map<String, dynamic> map) {
    return MuscleGroup(
      id: map['id'],
      name: map['name'] ?? '',
      image: map['image'],
    );
  }
}
