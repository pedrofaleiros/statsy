import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/domain/repository/question_repository.dart';

class QuestionUsecase {
  final QuestionRepository _repository;

  QuestionUsecase(this._repository);

  Stream<List<QuestionModel>> stream(String lessonId) {
    return _repository.streamQuestions(lessonId).map(
          (snapshot) => snapshot.docs
              .map((e) => QuestionModel.fromMap(e.data(), e.id))
              .toList(),
        );
  }

  Future<List<QuestionModel>> list(String lessonId) async {
    final data = await _repository.listQuestions(lessonId);
    return data.docs
        .map((doc) => QuestionModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<String?> save(QuestionModel question) async {
    if (question.content == "" || question.content.length > 32) {
      return "Conteúdo inválido";
    }
    await _repository.save(question);
    return null;
  }
}
