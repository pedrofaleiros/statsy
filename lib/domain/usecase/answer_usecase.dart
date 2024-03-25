import 'package:firebase_auth/firebase_auth.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/repository/answer_repository.dart';

class AnswerUsecase {
  final AnswerRepository _repository;

  AnswerUsecase(this._repository);

  Future<String?> answer(AnswerModel answer) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return "Não autorizado";
    }
    answer = answer.copyWith(userId: userId);
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
}
