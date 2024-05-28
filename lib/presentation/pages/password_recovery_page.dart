import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
import 'package:statsy/utils/app_colors.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  static const routeName = '/recovery';

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final _emailController = TextEditingController();

  Future<void> _handle() async {
    FocusScope.of(context).unfocus();

    final viewmodel = context.read<AuthViewmodel>();

    viewmodel.onError = (String? message) {
      showMessageSnackBar(context: context, message: message ?? "");
    };

    viewmodel.onSuccess = () async {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Verifique seu email para redefinir a senha.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      ).then((value) => Navigator.pop(context));
    };

    await viewmodel.passwordRecovery(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _emailTextField(),
            const SizedBox(height: 8),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextField(
      controller: _emailController,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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

  Widget _button() {
    bool loading = context.watch<AuthViewmodel>().isLoading;

    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.black
                : AppColors.white,
          ),
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.white
                : AppColors.black,
          ),
          overlayColor: const MaterialStatePropertyAll(AppColors.grey),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
          ),
        ),
        onPressed: _handle,
        child: const Text('Enviar'),
      ),
    );
  }
}
