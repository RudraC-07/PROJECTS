class Category {
  final int? id;
  final String name;
  final String? image;

  Category({
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

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'] ?? '',
      image: map['image'],
    );
  }
}
