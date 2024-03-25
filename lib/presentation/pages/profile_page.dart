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
        title: const Text('Perfil'),
        leading: const Icon(Icons.person),
        actions: [
          IconButton(
            onPressed: () async => await context.read<AuthViewmodel>().logout(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          if (isAdmin()) _editLessons(context),
        ],
      ),
    );
  }

  Widget _editLessons(BuildContext context) => ListTile(
        title: const Text("Editar Lições"),
        trailing: IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, EditLessonsPage.routeName),
          icon: const Icon(Icons.arrow_forward_ios),
        ),
        leading: const Card(
          color: AppColors.blue,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.edit,
              color: AppColors.white,
            ),
          ),
        ),
      );
}
