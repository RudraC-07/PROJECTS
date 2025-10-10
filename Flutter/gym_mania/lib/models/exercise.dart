class Exercise {
  final int? id;
  final String name;
  final String? description;
  final int categoryId;
  final String? difficulty;
  final String? image;

  Exercise({
    this.id,
    required this.name,
    this.description,
    required this.categoryId,
    this.difficulty,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category_id': categoryId,
      'difficulty': difficulty,
      'image': image,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'],
      categoryId: map['category_id'] ?? 0,
      difficulty: map['difficulty'],
      image: map['image'],
    );
  }
}
