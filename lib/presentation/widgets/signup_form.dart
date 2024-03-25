import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/presentation/widgets/google_signin_button.dart';
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
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  bool _obscurePasswordText = true;
  bool _obscurePasswordConfirmationText = true;

  bool _verifyPasswordMatches() {
    return _passwordConfirmationController.text == _passwordController.text;
  }

  Future<void> _signUp() async {
    FocusScope.of(context).unfocus();

    final viewmodel = context.read<AuthViewmodel>();

    viewmodel.onError = (String? message) {
      showMessageSnackBar(context: context, message: message ?? "");
    };

    viewmodel.onSuccess = () {};

    if (!_verifyPasswordMatches()) {
      showMessageSnackBar(context: context, message: 'Senhas inválidas');
      return;
    }
    await viewmodel.createUser(
      _emailController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: _boxDecoration,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _emailTextField,
            const SizedBox(height: 2),
            _passwordTextField,
            const SizedBox(height: 2),
            _passwordConfirmationTextField,
            const SizedBox(height: 16),
            _signUpButton,
            const SizedBox(height: 8),
            _divider,
            const SizedBox(height: 8),
            const GoogleSignInButton(),
            const SizedBox(height: 16),
            gotoLoginButton,
          ],
        ),
      ),
    );
  }

  Widget get _signUpButton {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        color: _getButtonColor(),
        onPressed: context.watch<AuthViewmodel>().isLoading ? null : _signUp,
        child: Text(
          'Cadastrar',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? AppColors.white
                : AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget get _emailTextField {
    return TextField(
      textInputAction: TextInputAction.next,
      controller: _emailController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(2),
          ),
        ),
        filled: true,
        fillColor: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? AppColors.black.withOpacity(0.75)
            : AppColors.white.withOpacity(0.75),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        hintText: 'Email',
      ),
    );
  }

  Widget get _passwordTextField {
    return TextField(
      obscureText: _obscurePasswordText,
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      decoration: InputDecoration(
        suffixIcon: _visibilityButton(),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(2),
          ),
        ),
        filled: true,
        fillColor: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? AppColors.black.withOpacity(0.75)
            : AppColors.white.withOpacity(0.75),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        hintText: 'Senha',
      ),
    );
  }

  Widget get _passwordConfirmationTextField {
    return TextField(
      obscureText: _obscurePasswordConfirmationText,
      textInputAction: TextInputAction.done,
      controller: _passwordConfirmationController,
      decoration: InputDecoration(
        suffixIcon: _visibilityConfirmatiobButton(),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        filled: true,
        fillColor: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? AppColors.black.withOpacity(0.75)
            : AppColors.white.withOpacity(0.75),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        hintText: 'Confirme sua senha',
      ),
    );
  }

  Widget _visibilityButton() {
    return IconButton(
      onPressed: () =>
          setState(() => _obscurePasswordText = !_obscurePasswordText),
      icon: Icon(
        _obscurePasswordText ? Icons.visibility_off : Icons.visibility,
      ),
    );
  }

  Widget _visibilityConfirmatiobButton() {
    return IconButton(
      onPressed: () => setState(() =>
          _obscurePasswordConfirmationText = !_obscurePasswordConfirmationText),
      icon: Icon(
        _obscurePasswordConfirmationText
            ? Icons.visibility_off
            : Icons.visibility,
      ),
    );
  }

  Widget get gotoLoginButton {
    return TextButton.icon(
      onPressed: () {
        widget.pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      icon: const Icon(Icons.help_outline, color: AppColors.black, size: 16),
      label: const Text(
        "Já possuo uma conta",
        style: TextStyle(color: AppColors.black),
      ),
    );
  }

  Widget get _divider => Divider(
        color: AppColors.white.withOpacity(0.5),
        height: 16,
        thickness: 0.5,
        indent: 64,
        endIndent: 64,
      );

  Color _getButtonColor() =>
      MediaQuery.of(context).platformBrightness == Brightness.dark
          ? AppColors.black.withOpacity(0.75 / 2)
          : AppColors.white.withOpacity(0.75 / 2);

  BoxDecoration get _boxDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blue,
            AppColors.green,
          ],
        ),
      );
}
