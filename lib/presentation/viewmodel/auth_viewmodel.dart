import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:statsy/domain/models/user_data_model.dart';
import 'package:statsy/domain/usecase/auth_usecase.dart';
import 'package:statsy/domain/usecase/user_data_usecase.dart';
import 'package:statsy/utils/service_locator.dart';

class AuthViewmodel extends ChangeNotifier {
  final _usecase = locator<AuthUsecase>();
  final _userDataUsecase = locator<UserDataUsecase>();

  Function(String? message)? onError;
  Function()? onSuccess;

  bool isLoading = false;

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> loginGoogle() async {
    setIsLoading(true);
    OAuthCredential? credential = await _usecase.loginGoogle();

    if (credential != null) {
      try {
        await FirebaseAuth.instance.signInWithCredential(credential);
        onSuccess?.call();
      } on FirebaseAuthException catch (e) {
        _handleGoogleAuthException(e);
      }
    }
    setIsLoading(false);
  }

  Future<void> login(String email, String password) async {
    setIsLoading(true);
    try {
      final response = await _usecase.login(email, password);
      if (response == null) {
        onSuccess?.call();
      } else {
        onError?.call(response);
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseLoginException(e);
    }
    setIsLoading(false);
  }

  Future<void> createUser({
    required String email,
    required String password,
    required String username,
  }) async {
    setIsLoading(true);
    try {
      final response = await _usecase.createUser(
        email: email,
        username: username,
        password: password,
      );

      if (response == null) {
        final userId = FirebaseAuth.instance.currentUser!.uid;

        final userData = UserDataModel(
          username: username,
          userId: userId,
          level: 1,
          points: 0,
        );
        _userDataUsecase.save(userData);

        onSuccess?.call();
      } else {
        onError?.call(response);
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseCreateUserException(e);
    }
    setIsLoading(false);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> passwordRecovery(String email) async {
    setIsLoading(true);
    try {
      await _usecase.passwordRecovery(email);
      onSuccess?.call();
    } on FirebaseAuthException catch (e) {
      _handlePasswordRecoveryException(e);
    }
    setIsLoading(false);
  }

  void _handleGoogleAuthException(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      onError?.call("Conta já cadastrada com outro metodo de entrada.");
    } else if (e.code == 'invalid-credential') {
      onError?.call("Credenciais inválidas.");
    } else if (e.code == 'operation-not-allowed') {
      onError?.call("Tente outra forma de entrada.");
    } else if (e.code == 'user-disabled') {
      onError?.call("A conta desse usuário foi desabilitada.");
    } else if (e.code == 'user-not-found') {
      onError?.call("Nenhuma conta encontrada com esse email.");
    } else if (e.code == 'invalid-verification-code') {
      onError?.call("Código de verificação inválido.");
    } else if (e.code == 'invalid-verification-id') {
      onError?.call("Código de verificação inválido.");
    }
  }

  void _handlePasswordRecoveryException(FirebaseAuthException e) {
    if (e.code == 'invalid-email') {
      onError?.call("Email não cadastrado");
    } else if (e.code == 'user-not-found') {
      onError?.call("Email inválido");
    } else {
      onSuccess?.call();
    }
  }

  void _handleFirebaseLoginException(FirebaseAuthException e) {
    if (e.code == 'invalid-email') {
      onError?.call("Email inválido.");
    } else if (e.code == 'user-not-found') {
      onError?.call("Usuário não encontrado.");
    } else if (e.code == 'wrong-password') {
      onError?.call("Senha incorreta.");
    } else if (e.code == 'user-disabled') {
      onError?.call("Usuário inválido.");
    } else if (e.code == 'too-many-requests') {
      onError?.call("Muitos requests. Tente novamente mais tarde.");
    } else if (e.code == 'invalid-credential') {
      onError?.call(
        "Credenciais inválidas. Tente outra senha ou método de entrada.",
      );
    }
  }

  void _handleFirebaseCreateUserException(FirebaseAuthException e) {
    if (e.code case 'email-already-in-use') {
      onError?.call("Email já utilizado.");
    } else if (e.code case 'invalid-email') {
      onError?.call("Email inválido.");
    } else if (e.code case 'operation-not-allowed') {
      onError?.call("Não autorizado.");
    } else if (e.code case 'weak-password') {
      onError?.call("Escolha uma senha mais forte.");
    }
  }
}
