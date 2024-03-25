// ignore_for_file: unused_local_variable, dead_code

import 'package:firebase_auth/firebase_auth.dart';

bool isAdmin() {
  return true;
  final userEmail = FirebaseAuth.instance.currentUser!.email;
}
