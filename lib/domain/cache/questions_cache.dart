import 'package:statsy/domain/models/question_model.dart';

class QuestionsCache {
  static final QuestionsCache _instance = QuestionsCache._interno();

  QuestionsCache._interno();

  static QuestionsCache get instance => _instance;

  final Map<String, List<QuestionModel>> _map = {};

  void set(String lessonId, List<QuestionModel> list) {
    _map[lessonId] = [...list];
  }

  List<QuestionModel>? get(String lessonId) {
    final list = _map[lessonId];
    if (list == null) return null;
    return [...list];
  }
}
