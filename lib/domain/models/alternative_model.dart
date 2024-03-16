class AlternativeModel {
  final String id;
  final String text;
  final bool isCorrect;
  final String questionId;

  AlternativeModel({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.questionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isCorrect': isCorrect,
      'questionId': questionId,
    };
  }

  factory AlternativeModel.fromMap(Map<String, dynamic> map, String id) {
    return AlternativeModel(
      id: id,
      text: map['text'],
      isCorrect: map['isCorrect'],
      questionId: map['questionId'],
    );
  }

  AlternativeModel copyWith({
    String? id,
    String? text,
    bool? isCorrect,
    String? questionId,
  }) {
    return AlternativeModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
      questionId: questionId ?? this.questionId,
    );
  }
}
