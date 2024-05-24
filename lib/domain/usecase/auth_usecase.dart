import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:statsy/utils/firestore_constants.dart';

class AuthUsecase {
  Future<String?> login(String email, String password) async {
    if (email == "" || password == "") {
      return "Preencha todos os campos.";
    }
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return null;
  }

  Future<String?> createUser({
    required String email,
    required String password,
    required String username,
  }) async {
    if (email == "" || password == "") return "Preencha todos os campos.";

    if (username.length < 2 || username.length > 32) {
      return "Nome de usuário inválido";
    }

    final db = FirebaseFirestore.instance;
    final data = await db
        .collection(FireConst.USER_DATA)
        .where("username", isEqualTo: username)
        .get();

    if (data.docs.isNotEmpty) return "Já existe um usuário com esse nome";

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return null;
  }

  Future<OAuthCredential?> loginGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

    if (googleAccount != null) {
      GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      OAuthCredential cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      return cred;
    }
    return null;
  }

  Future<void> passwordRecovery(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
