import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/repository/lesson_repository.dart';
import 'package:statsy/utils/firestore_constants.dart';

class LessonRepositoryImpl implements LessonRepository {
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamLessons() {
    final db = FirebaseFirestore.instance;
    return db
        .collection(FireConst.LESSON)
        .orderBy("level", descending: false)
        .snapshots();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> listLessons() async {
    final db = FirebaseFirestore.instance;
    return await db
        .collection(FireConst.LESSON)
        .orderBy('level', descending: false)
        .get();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamLessonsByLevel(
    int level,
  ) {
    final db = FirebaseFirestore.instance;
    return db
        .collection(FireConst.LESSON)
        .where('level', isEqualTo: level)
        .orderBy('__name__')
        .snapshots();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> listLessonsByLevel(
    int level,
  ) async {
    final db = FirebaseFirestore.instance;
    return await db
        .collection(FireConst.LESSON)
        .where('level', isEqualTo: level)
        .orderBy('__name__')
        .get();
  }

  @override
  Future<void> save(LessonModel lesson) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.LESSON).doc(lesson.id);
    await ref.set(lesson.toMap());
  }

  @override
  Future<void> delete(String id) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.LESSON).doc(id);
    await ref.delete();
  }
}
