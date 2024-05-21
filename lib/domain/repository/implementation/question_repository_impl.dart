import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/domain/repository/question_repository.dart';
import 'package:statsy/utils/firestore_constants.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamQuestions(String lessonId) {
    final db = FirebaseFirestore.instance;
    return db
        .collection(FireConst.QUESTION)
        .where("lessonId", isEqualTo: lessonId)
        .orderBy("peso", descending: false)
        .snapshots();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> listQuestions(
      String lessonId) async {
    final db = FirebaseFirestore.instance;
    return await db
        .collection(FireConst.QUESTION)
        .where("lessonId", isEqualTo: lessonId)
        .orderBy("peso", descending: false)
        .get();
  }

  @override
  Future<void> save(QuestionModel question) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.QUESTION).doc(question.id);
    await ref.set(question.toMap());
  }

  @override
  Future<void> delete(String id) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.QUESTION).doc(id);
    await ref.delete();
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> detail(String id) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.QUESTION).doc(id);
    return ref.get();
  }
}
