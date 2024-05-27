import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:statsy/domain/models/user_data_model.dart';

abstract class UserDataRepository {
  Future<void> save(UserDataModel userData);

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String id);

  Future<QuerySnapshot<Map<String, dynamic>>> listAllUsers();
}
