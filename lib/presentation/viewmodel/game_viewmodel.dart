import 'package:flutter/foundation.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/domain/usecase/question_usecase.dart';
import 'package:statsy/utils/service_locator.dart';

class GameViewmodel extends ChangeNotifier {
  final _questionUsecase = locator<QuestionUsecase>();

  List<QuestionModel> questions = [];

  Future<void> getQuestions(String lessonId) async {
    questions = await _questionUsecase.list(lessonId);
    notifyListeners();
  }
}
