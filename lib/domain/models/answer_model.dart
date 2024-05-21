class AnswerModel {
  final String userId;
  final String questionId;
  final String alternativeId;
  final bool isCorrect;

  AnswerModel({
    required this.userId,
    required this.questionId,
    required this.alternativeId,
    required this.isCorrect,
  });

  String get id => "$userId.$questionId";

  static getId(String userId, String questionId) {
    final ans = AnswerModel(
      userId: userId,
      questionId: questionId,
      alternativeId: "",
      isCorrect: false,
    );
    return ans.id;
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "questionId": questionId,
      "alternativeId": alternativeId,
      "isCorrect": isCorrect,
    };
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      userId: map['userId'],
      questionId: map['questionId'],
      alternativeId: map['alternativeId'],
      isCorrect: map['isCorrect'],
    );
  }

  AnswerModel copyWith({
    String? userId,
    String? questionId,
    String? alternativeId,
    bool? isCorrect,
  }) {
    return AnswerModel(
      userId: userId ?? this.userId,
      alternativeId: alternativeId ?? this.alternativeId,
      questionId: questionId ?? this.questionId,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
