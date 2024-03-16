class QuestionModel {
  final String id;
  final String content;
  final String lessonId;
  final String? imageUrl;

  QuestionModel({
    required this.id,
    required this.content,
    required this.lessonId,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "content": content,
      "lessonId": lessonId,
      "imageUrl": imageUrl,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map, String id) {
    return QuestionModel(
      id: id,
      content: map['content'],
      lessonId: map['lessonId'],
      imageUrl: map['imageUrl'],
    );
  }

  QuestionModel copyWith({
    String? id,
    String? content,
    String? lessonId,
    String? imageUrl,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      content: content ?? this.content,
      lessonId: lessonId ?? this.lessonId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
