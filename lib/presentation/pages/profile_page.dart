import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';

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
    );
  }
}
