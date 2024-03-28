import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/repository/answer_repository.dart';
import 'package:statsy/utils/firestore_constants.dart';

class AnswerRepositoryImpl implements AnswerRepository {
  @override
  Future<void> answerQuestion(AnswerModel answer) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.ANSWER).doc(answer.id);
    await ref.set(answer.toMap());
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserAnswer(
    String userId,
    String questionId,
  ) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.ANSWER).doc(
          AnswerModel.getId(userId, questionId),
        );
    return await ref.get();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> list(String userId) async {
    final db = FirebaseFirestore.instance;
    return await db
        .collection(FireConst.ANSWER)
        .where("userId", isEqualTo: userId)
        .get();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String userId) {
    final db = FirebaseFirestore.instance;
    return db
        .collection(FireConst.ANSWER)
        .where("userId", isEqualTo: userId)
        .snapshots();
  }
}
