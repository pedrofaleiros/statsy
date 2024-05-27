import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/user_data_viewmodel.dart';
import 'package:statsy/utils/is_waiting.dart';

class UserProgress extends StatelessWidget {
  const UserProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<UserDataViewmodel>().getUserData(),
      builder: (context, snapshot) {
        if (isWaiting(snapshot) || !snapshot.hasData) {
          return Container();
        }

        final data = snapshot.data!;
        return Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: const Text('Nivel'),
                trailing: Text(
                  '${data.level}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: const Text('Pontos'),
                trailing: Text(
                  '${data.points}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
