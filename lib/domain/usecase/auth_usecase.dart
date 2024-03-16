import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<String?> createUser(String email, String password) async {
    if (email == "" || password == "") {
      return "Preencha todos os campos.";
    }
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
}
