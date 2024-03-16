// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/presentation/widgets/login_form.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
import 'package:statsy/presentation/widgets/signup_form.dart';
import 'package:statsy/utils/app_colors.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  static const routeName = "/auth";

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            LoginForm(pageController: _pageController),
            SignUpForm(pageController: _pageController),
          ],
        ),
      ),
    );
  }
}
