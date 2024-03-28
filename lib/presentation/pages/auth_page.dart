import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/presentation/widgets/login_form.dart';
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
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: [
                LoginForm(pageController: _pageController),
                SignUpForm(pageController: _pageController),
              ],
            ),
            const LoadingStackWidget(),
            // _googleButton,
          ],
        ),
      ),
    );
  }
}

class LoadingStackWidget extends StatelessWidget {
  const LoadingStackWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewmodel>(builder: (context, viewmodel, _) {
      return viewmodel.isLoading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.white,
                ),
              ),
            )
          : Container(
              color: AppColors.red,
              width: 0,
              height: 0,
            );
    });
  }
}
