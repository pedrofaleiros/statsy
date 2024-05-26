import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/pages/password_recovery_page.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
import 'package:statsy/utils/app_colors.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final viewmodel = context.read<AuthViewmodel>();

    viewmodel.onError = (String? message) {
      showMessageSnackBar(context: context, message: message ?? "");
    };

    viewmodel.onSuccess = () {};

    await viewmodel.login(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logo(),
            _box(16),
            const Text(
              'Insira seus dados para entrar na conta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            _box(32),
            _emailTextField(),
            _box(8),
            _passwordTextField(),
            _box(16),
            _loginButton(),
            _box(32),
            _divider(),
            _box(16),
            Row(
              children: [
                _passwordRecoveryButton(),
                Card(child: _signupButton()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return Card(
      elevation: 0,
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              width: 64,
              height: 64,
            ),
            const Text(
              'Statsy',
              style: TextStyle(
                fontFamily: 'OrelegaOne',
                color: AppColors.dark,
                fontSize: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(double height) => SizedBox(height: height);

  Widget _passwordRecoveryButton() {
    return TextButton(
      onPressed: () =>
          Navigator.pushNamed(context, PasswordRecoveryPage.routeName),
      child: const Text(
        'Esqueci minha senha',
        style: TextStyle(color: AppColors.grey),
      ),
    );
  }

  Widget _signupButton() {
    return TextButton(
      onPressed: () {
        widget.pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: const Text(
        'Não tenho uma conta',
        style: TextStyle(color: AppColors.grey),
      ),
    );
  }

  Widget _divider() {
    return const Row(children: [
      Expanded(child: Divider()),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Text("ou"),
      ),
      Expanded(child: Divider()),
    ]);
  }

  Widget _loginButton() {
    bool loading = context.watch<AuthViewmodel>().isLoading;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(loading ? null : AppColors.blue),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
          ),
        ),
        onPressed: loading ? null : _login,
        child: loading ? _loading() : _loginButtonText(),
      ),
    );
  }

  Widget _loginButtonText() {
    return Text(
      'Entrar',
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
    return const SizedBox(
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
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.blue,
            width: 2,
          ),
        ),
        hintText: 'Digite seu email',
      ),
    );
  }

  Widget _passwordTextField() {
    return TextField(
      onSubmitted: (value) {
        if (!context.read<AuthViewmodel>().isLoading) _login();
      },
      obscureText: _obscureText,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscureText = !_obscureText),
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
          ),
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.blue,
            width: 2,
          ),
        ),
        hintText: 'Digite sua senha',
      ),
    );
  }
}
