import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/question_model.dart';

abstract class QuestionRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> streamQuestions(String lessonId);

  Future<QuerySnapshot<Map<String, dynamic>>> listQuestions(String lessonId);

  Future<void> save(QuestionModel question);

  Future<void> delete(String id);

  Future<DocumentSnapshot<Map<String, dynamic>>> detail(String id);
}
