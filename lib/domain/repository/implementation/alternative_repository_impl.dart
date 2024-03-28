import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/repository/alternative_repository.dart';
import 'package:statsy/utils/firestore_constants.dart';

class AlternativeRepositoryImpl implements AlternativeRepository {
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String questionId) {
    final db = FirebaseFirestore.instance;
    return db
        .collection(FireConst.ALTERNATIVE)
        .where("questionId", isEqualTo: questionId)
        .snapshots();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> list(String questionId) async {
    final db = FirebaseFirestore.instance;
    return await db
        .collection(FireConst.ALTERNATIVE)
        .where("questionId", isEqualTo: questionId)
        .get();
  }

  @override
  Future<void> save(AlternativeModel alternative) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.ALTERNATIVE).doc(alternative.id);
    await ref.set(alternative.toMap());
  }

  @override
  Future<void> delete(String id) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.ALTERNATIVE).doc(id);
    await ref.delete();
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> detail(String id) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.ALTERNATIVE).doc(id);
    return ref.get();
  }
}
