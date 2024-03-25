import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/lesson_model.dart';

abstract class LessonRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> streamLessons();

  Future<QuerySnapshot<Map<String, dynamic>>> listLessons();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLessonsByLevel(int level);

  Future<QuerySnapshot<Map<String, dynamic>>> listLessonsByLevel(int level);

  Future<void> save(LessonModel lesson);

  Future<void> delete(String id);
}
