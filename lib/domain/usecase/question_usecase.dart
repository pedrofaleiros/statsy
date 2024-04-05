// ignore_for_file: avoid_print

import 'package:statsy/domain/cache/questions_cache.dart';
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
    final cache = QuestionsCache.instance.get(lessonId);
    if (cache != null) return cache;

    final data = await _repository.listQuestions(lessonId);
    final list = data.docs
        .map((doc) => QuestionModel.fromMap(doc.data(), doc.id))
        .toList();

    QuestionsCache.instance.set(lessonId, list);
    return list;
  }

  Future<String?> save(QuestionModel question) async {
    question = replace(question);

    if (question.content == "" || question.content.length > 1000) {
      return "Conteúdo inválido";
    }
    await _repository.save(question);
    return null;
  }

  QuestionModel replace(QuestionModel question) {
    question = question.copyWith(
      content: question.content.replaceAll('\n', ''),
    );
    question = question.copyWith(
      content: question.content.replaceAll('\r', ''),
    );
    question = question.copyWith(
      content: question.content.replaceAll('  ', ''),
    );
    return question;
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
  }

  Future<QuestionModel?> detail(String id) async {
    final data = await _repository.detail(id);

    if (data.data() != null) {
      return QuestionModel.fromMap(data.data()!, data.id);
    }
    return null;
  }
}
