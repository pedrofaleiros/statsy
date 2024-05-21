import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/domain/usecase/question_usecase.dart';
import 'package:statsy/utils/service_locator.dart';

class QuestionViewmodel {
  final _usecase = locator<QuestionUsecase>();

  Stream<List<QuestionModel>> streamQuestions(String lessonId) {
    return _usecase.stream(lessonId);
  }

  Future<List<QuestionModel>> listQuestions(String lessonId) async {
    return await _usecase.list(lessonId);
  }

  Future<List<QuestionModel>> listAllQuestions() async {
    try {
      return await _usecase.listAll();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveQuestion(QuestionModel question) async {
    final res = await _usecase.save(question);
    if (res == null) {
      onSuccess?.call();
    } else {
      onError?.call(res);
    }
  }

  Future<void> delete(String id) async {
    await _usecase.delete(id);
    onSuccess?.call();
  }

  Function()? onSuccess;
  Function(String message)? onError;
}
