import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/pages/admin/edit_lessons_page.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:statsy/utils/is_admin.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.black,
        title: const Text('Perfil'),
        leading: const Icon(Icons.person),
        actions: [
          if (isAdmin()) _editLessons(context),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Container()),
            _logout(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _editLessons(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pushNamed(context, EditLessonsPage.routeName),
      icon: const Icon(Icons.edit),
    );
  }

  Widget _logout(BuildContext context) => Card(
        margin: const EdgeInsets.all(8),
        child: ListTile(
          onTap: () async {
            await context.read<AuthViewmodel>().logout();
          },
          title: const Text("Sair"),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.grey,
          ),
        ),
      );
}
