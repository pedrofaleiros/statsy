import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/repository/answer_repository.dart';

class AnswerUsecase {
  final AnswerRepository _repository;

  AnswerUsecase(this._repository);

  Future<String?> answer(AnswerModel answer) async {
    if (answer.userId == "") {
      return "Não autorizado";
    }
    await _repository.answerQuestion(answer);
    return null;
  }

  Future<AnswerModel?> getUserAnswer(String userId, String questionId) async {
    final data = await _repository.getUserAnswer(userId, questionId);
    if (data.data() != null) {
      return AnswerModel.fromMap(data.data()!);
    }
    return null;
  }

  Future<List<AnswerModel>> listUserAnswers(String userId) async {
    final data = await _repository.list(userId);

    final list =
        data.docs.map((doc) => AnswerModel.fromMap(doc.data())).toList();

    return list;
  }
}

/* 
  Future<List<QuestionModel>> list(String lessonId) async {
      final cache = QuestionsCache.instance.get(lessonId);
      if (cache != null) return cache;

      final data = await _repository.listQuestions(lessonId);
      final list = data.docs
          .map((doc) => QuestionModel.fromMap(doc.data(), doc.id))
          .toList();

      QuestionsCache.instance.set(lessonId, list);
      return list;
  }

 */
