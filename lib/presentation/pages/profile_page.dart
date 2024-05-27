import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/pages/admin/edit_lessons_page.dart';
import 'package:statsy/presentation/pages/progress_page.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/user_data_viewmodel.dart';
import 'package:statsy/presentation/widgets/app_bar_title.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:statsy/utils/is_admin.dart';
import 'package:statsy/utils/is_waiting.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deseja sair da sua conta?'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Não",
              style: TextStyle(color: AppColors.red),
            ),
          ),
          TextButton(
            onPressed: () async => await context
                .read<AuthViewmodel>()
                .logout()
                .then((value) => Navigator.pop(context)),
            child: const Text(
              "Sim",
              style: TextStyle(color: AppColors.blue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: _username(context),
          subtitle: Text(FirebaseAuth.instance.currentUser?.email ?? ""),
        ),
        actions: [if (isAdmin()) _editLessons(context)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          child: Column(
            children: [
              _progress(context),
              const Divider(height: 0, indent: 16, endIndent: 16),
              _logout(context),
              const Divider(height: 0, indent: 16, endIndent: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _username(BuildContext context) {
    return FutureBuilder(
      future: context.read<UserDataViewmodel>().getUserData(),
      builder: (context, snapshot) {
        if (isWaiting(snapshot) || !snapshot.hasData) {
          return Container();
        }

        final data = snapshot.data!;
        final username = data.username;

        return AppBarTitle(text: username);
      },
    );
  }

  Widget _editLessons(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pushNamed(context, EditLessonsPage.routeName),
      icon: const Icon(Icons.edit),
    );
  }

  Widget _logout(BuildContext context) => ListTile(
        onTap: () async => await _logoutDialog(context),
        title: const Text("Sair"),
        trailing: const Icon(
          Icons.logout,
          color: AppColors.grey,
        ),
      );

  Widget _progress(BuildContext context) => ListTile(
        onTap: () => Navigator.pushNamed(context, ProgressPage.routeName),
        title: const Text("Progresso"),
        trailing: const Icon(
          Icons.insert_chart_outlined_rounded,
          color: AppColors.grey,
        ),
      );
}
