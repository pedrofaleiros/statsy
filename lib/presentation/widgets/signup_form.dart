// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
import 'package:statsy/utils/app_colors.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  State<SignUpForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<SignUpForm> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  Future<void> _signUp() async {
    FocusScope.of(context).unfocus();

    final viewmodel = context.read<AuthViewmodel>();

    viewmodel.onError = (String? message) {
      showMessageSnackBar(context: context, message: message ?? "");
    };

    viewmodel.onSuccess = () {};

    await viewmodel.createUser(
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Insira seus dados para criar uma conta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            _box(32),
            _emailTextField(),
            _box(8),
            _usernameTextField(),
            _box(8),
            _passwordTextField(),
            _box(16),
            _signUpButton(),
            _box(32),
            _divider(),
            _box(16),
            _loginButton(),
          ],
        ),
      ),
    );
  }

  Widget _box(double height) => SizedBox(height: height);

  Widget _loginButton() {
    return TextButton(
      onPressed: () {
        widget.pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Text(
        'Já tenho uma conta',
        style: TextStyle(color: AppColors.grey),
      ),
    );
  }

  Widget _divider() {
    return Row(children: [
      Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text("ou"),
      ),
      Expanded(child: Divider()),
    ]);
  }

  Widget _signUpButton() {
    bool loading = context.watch<AuthViewmodel>().isLoading;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(loading ? null : AppColors.purple),
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
          ),
        ),
        onPressed: loading ? null : _signUp,
        child: loading ? _loading() : _signUpButtonText(),
      ),
    );
  }

  Widget _signUpButtonText() {
    return Text(
      'Cadastrar',
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 18,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.black
            : AppColors.white,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _loading() {
    return SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.white,
      ),
    );
  }

  Widget _emailTextField() {
    return TextField(
      controller: _emailController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.purple,
            width: 2,
          ),
        ),
        hintText: 'Digite seu email',
      ),
    );
  }

  Widget _usernameTextField() {
    return TextField(
      controller: _usernameController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.purple,
            width: 2,
          ),
        ),
        hintText: 'Digite seu nome de usuário',
      ),
    );
  }

  Widget _passwordTextField() {
    return TextField(
      onSubmitted: (value) {
        if (!context.read<AuthViewmodel>().isLoading) _signUp();
      },
      obscureText: _obscureText,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscureText = !_obscureText),
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
          ),
        ),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.purple,
            width: 2,
          ),
        ),
        hintText: 'Digite sua senha',
      ),
    );
  }
}
