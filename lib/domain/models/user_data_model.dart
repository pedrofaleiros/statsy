class UserDataModel {
  final String userId;
  final String username;
  final int level;
  final int points;

  UserDataModel({
    required this.userId,
    required this.username,
    required this.level,
    required this.points,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'level': level,
      'points': points,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map, String userId) {
    return UserDataModel(
      userId: userId,
      username: map['username'],
      level: map['level'],
      points: map['points'],
    );
  }

  UserDataModel copyWith({
    String? userId,
    String? username,
    int? level,
    int? points,
  }) {
    return UserDataModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      level: level ?? this.level,
      points: points ?? this.points,
    );
  }
}
