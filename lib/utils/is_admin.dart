import 'package:firebase_auth/firebase_auth.dart';

bool isAdmin() {
  return true;
  final userEmail = FirebaseAuth.instance.currentUser!.email;
}
