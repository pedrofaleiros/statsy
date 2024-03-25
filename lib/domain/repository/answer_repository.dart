import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/answer_model.dart';

abstract class AnswerRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String userId);
  Future<QuerySnapshot<Map<String, dynamic>>> list(String userId);

  Future<void> answerQuestion(AnswerModel answer);

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserAnswer(
    String userId,
    String questionId,
  );
}
