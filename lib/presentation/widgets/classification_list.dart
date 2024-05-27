import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/user_data_viewmodel.dart';
import 'package:statsy/presentation/widgets/app_bar_title.dart';
import 'package:statsy/presentation/widgets/app_logo.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/utils/is_waiting.dart';

class ClassificationList extends StatelessWidget {
  const ClassificationList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return FutureBuilder(
      future: context.read<UserDataViewmodel>().listAll(),
      builder: (context, snapshot) {
        if (isWaiting(snapshot) || !snapshot.hasData) {
          return Container();
        }

        final data = snapshot.data!;
        return Expanded(
          child: ListView(
            children: [
              const ListTile(
                title: AppBarTitle(text: 'Classificação'),
                trailing: AppLogo(size: 24),
              ),
              const ListTile(
                leading: Text('Nível'),
                trailing: Text('Pontos'),
              ),
              for (var p in data)
                ListTile(
                  title: Text(
                    "${p.username} ${userId != null && userId == p.userId ? "(Você)" : ""}",
                    style: TextStyle(
                      fontWeight: userId != null && userId == p.userId
                          ? FontWeight.bold
                          : null,
                    ),
                  ),
                  trailing: Text("${p.points}"),
                  leading: AppBarTitle(
                    text: "${p.level}",
                    color: getLevelColor(p.level),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
