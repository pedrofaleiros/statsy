import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/firestore_model.dart';

abstract class FirestoreRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> stream();

  Future<QuerySnapshot<Map<String, dynamic>>> list();

  Future<void> save(FirestoreModel entity);
}
