class LessonModel {
  final String id;
  final String name;
  final String description;
  final int level;
  final int points;

  LessonModel({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.points,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map, String id) {
    return LessonModel(
      id: id,
      name: map['name'],
      description: map['description'],
      level: map['level'],
      points: map['points'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'level': level,
      'points': points,
    };
  }

  LessonModel copyWith({
    String? id,
    String? name,
    String? description,
    int? level,
    int? points,
  }) {
    return LessonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      points: points ?? this.points,
    );
  }
}
