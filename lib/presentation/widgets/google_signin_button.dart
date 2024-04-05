import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
import 'package:statsy/utils/app_colors.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  get context => null;

  Future<void> _signIn(BuildContext context) async {
    final viewmodel = context.read<AuthViewmodel>();

    viewmodel.onError = (String? message) {
      showMessageSnackBar(context: context, message: message ?? "Erro");
    };

    viewmodel.onSuccess = () {};

    await viewmodel.loginGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Consumer<AuthViewmodel>(builder: (context, viewmodel, _) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(0),
          color: AppColors.white,
          child: TextButton.icon(
            onPressed:
                viewmodel.isLoading ? null : () async => await _signIn(context),
            icon: _buttonIcon(),
            label: _buttonText(),
          ),
        );
      }),
    );
  }

  SvgPicture _buttonIcon() {
    return SvgPicture.asset(
      'assets/images/google_icon.svg',
      width: 32,
      height: 32,
    );
  }

  Text _buttonText() {
    return const Text(
      'Entrar com o Google',
      style: TextStyle(color: AppColors.grey),
    );
  }
}
