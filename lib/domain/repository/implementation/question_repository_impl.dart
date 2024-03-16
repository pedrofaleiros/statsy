import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/domain/repository/question_repository.dart';
import 'package:statsy/utils/firestore_constants.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final FirebaseFirestore db;

  QuestionRepositoryImpl() : db = FirebaseFirestore.instance;

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamQuestions(String lessonId) {
    return db
        .collection(FireConst.QUESTION)
        .where("lessonId", isEqualTo: lessonId)
        .snapshots();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> listQuestions(
      String lessonId) async {
    return await db
        .collection(FireConst.QUESTION)
        .where("lessonId", isEqualTo: lessonId)
        .get();
  }

  @override
  Future<void> save(QuestionModel question) async {
    final ref = db.collection(FireConst.QUESTION).doc(question.id);
    await ref.set(question.toMap());
  }
}
