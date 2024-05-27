import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/user_data_model.dart';
import 'package:statsy/domain/repository/user_data_repository.dart';
import 'package:statsy/utils/firestore_constants.dart';

class UserDataRepositoryImpl implements UserDataRepository {
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String id) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.USER_DATA).doc(id);
    return ref.get();
  }

  @override
  Future<void> save(UserDataModel userData) async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection(FireConst.USER_DATA).doc(userData.userId);
    await ref.set(userData.toMap());
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> listAllUsers() async {
    final db = FirebaseFirestore.instance;
    return await db
        .collection(FireConst.USER_DATA)
        .orderBy("points", descending: true)
        .get();
  }
}
