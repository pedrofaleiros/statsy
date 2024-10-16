import 'package:firebase_auth/firebase_auth.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/usecase/answer_usecase.dart';
import 'package:statsy/utils/service_locator.dart';

class AnswerViewmodel {
  final _usecase = locator<AnswerUsecase>();

  Future<void> testAnswer(AlternativeModel alt) async {
    if (alt.isCorrect) {
      onCorrect?.call();
    } else {
      onWrong?.call();
    }
  }

  Future<void> answer(AlternativeModel alt) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final answer = AnswerModel(
      userId: userId ?? "",
      alternativeId: alt.id,
      questionId: alt.questionId,
      isCorrect: alt.isCorrect,
    );

    final res = await _usecase.answer(answer);

    if (res != null) {
      onError?.call(res);
    } else {
      if (alt.isCorrect) {
        onCorrect?.call();
      } else {
        onWrong?.call();
      }
    }
  }

  Future<AnswerModel?> getAnswer(String questionId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return await _usecase.getUserAnswer(userId, questionId);
  }

  Future<List<AnswerModel>> listUserAnswers() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      return await _usecase.listUserAnswers(userId);
    } catch (e) {
      return [];
    }
  }

  Function(String? message)? onError;
  Function()? onCorrect;
  Function()? onWrong;
}
