import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/firestore_model.dart';
import 'package:statsy/domain/repository/firestore_repository.dart';

class FirestoreRepositoryImpl<T> implements FirestoreRepository {
  final String collection;

  FirestoreRepositoryImpl(this.collection);

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> list() {
    return FirebaseFirestore.instance.collection(collection).get();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> stream() {
    return FirebaseFirestore.instance.collection(collection).snapshots();
  }

  @override
  Future<void> save(FirestoreModel entity) async {
    final ref =
        FirebaseFirestore.instance.collection(collection).doc(entity.getId());
    await ref.set(entity.toMap());
  }
}
