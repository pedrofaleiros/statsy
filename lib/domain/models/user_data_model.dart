class UserDataModel {
  final String userId;
  final int level;
  final int points;

  UserDataModel({
    required this.userId,
    required this.level,
    required this.points,
  });

  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'points': points,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map, String userId) {
    return UserDataModel(
      userId: userId,
      level: map['level'],
      points: map['points'],
    );
  }

  UserDataModel copyWith({
    String? userId,
    int? level,
    int? points,
  }) {
    return UserDataModel(
      userId: userId ?? this.userId,
      level: level ?? this.level,
      points: points ?? this.points,
    );
  }
}
