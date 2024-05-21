import 'package:flutter/foundation.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/domain/usecase/question_usecase.dart';
import 'package:statsy/utils/service_locator.dart';

class GameViewmodel extends ChangeNotifier {
  final _questionUsecase = locator<QuestionUsecase>();

  List<QuestionModel> questions = [];

  int total = 0;

  Future<void> loadQuestions(String lessonId) async {
    questions.clear();
    total = 0;
    try {
      final data = await _questionUsecase.list(lessonId);
      questions = data.reversed.toList();
      total = questions.length;
      onSuccess?.call();
    } catch (e) {
      onError?.call("Erro ao iniciar lição.");
    } finally {
      notifyListeners();
    }
  }

  QuestionModel? pop() {
    if (questions.isEmpty) {
      return null;
    }
    return questions.removeLast();
  }

  Function()? onSuccess;
  Function(String? message)? onError;
}
