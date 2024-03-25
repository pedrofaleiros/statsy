import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/alternative_model.dart';

abstract class AlternativeRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> stream(String questionId);

  Future<QuerySnapshot<Map<String, dynamic>>> list(String questionId);

  Future<void> save(AlternativeModel alternative);

  Future<void> delete(String id);

  Future<DocumentSnapshot<Map<String, dynamic>>> detail(String id);
}
