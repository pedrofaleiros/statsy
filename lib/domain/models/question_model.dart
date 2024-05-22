class QuestionModel {
  final String id;
  final String content;
  final String lessonId;
  final String? imageUrl;
  final bool? hasImage;

  QuestionModel({
    required this.id,
    required this.content,
    required this.lessonId,
    this.imageUrl,
    this.hasImage,
  });

  Map<String, dynamic> toMap() {
    return {
      "content": content,
      "lessonId": lessonId,
      "imageUrl": imageUrl,
      "peso": 1,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map, String id) {
    return QuestionModel(
      id: id,
      content: map['content'],
      lessonId: map['lessonId'],
      imageUrl: map['imageUrl'],
      hasImage: map['imageUrl'] != null,
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
