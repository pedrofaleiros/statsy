import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/repository/answer_repository.dart';
import 'package:statsy/utils/firestore_constants.dart';

class AnswerRepositoryImpl implements AnswerRepository {
  final FirebaseFirestore db;

  AnswerRepositoryImpl() : db = FirebaseFirestore.instance;

  @override
  Future<void> answerQuestion(AnswerModel answer) async {
    final ref = db.collection(FireConst.ANSWER).doc(answer.id);
    await ref.set(answer.toMap());
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserAnswer(
    String userId,
    String questionId,
  ) async {
    final ref = db.collection(FireConst.ANSWER).doc(
          AnswerModel.getId(userId, questionId),
        );
    return await ref.get();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> list(String userId) async {
    return await db
        .collection(FireConst.ANSWER)
        .where("userId", isEqualTo: userId)
        .get();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String userId) {
    return db
        .collection(FireConst.ANSWER)
        .where("userId", isEqualTo: userId)
        .snapshots();
  }
}
