import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:statsy/presentation/pages/home_page.dart';
import 'package:statsy/presentation/pages/loading_page.dart';
import 'package:statsy/presentation/pages/auth_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const AuthPage();
      },
    );
  }
}
