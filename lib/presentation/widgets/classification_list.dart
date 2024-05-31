import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/user_data_viewmodel.dart';
import 'package:statsy/presentation/widgets/user_classification_tile.dart';
import 'package:statsy/utils/is_waiting.dart';

class ClassificationList extends StatelessWidget {
  const ClassificationList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<UserDataViewmodel>().listAll(),
      builder: (context, snapshot) {
        if (isWaiting(snapshot) || !snapshot.hasData) {
          return Container();
        }

        final data = snapshot.data!;
        final userId = FirebaseAuth.instance.currentUser?.uid ?? "";

        return Expanded(
          child: ListView(
            children: [
              for (var i = 0; i < data.length; i++)
                if (i < 10 || data[i].userId == userId)
                  UserClassificationTile(
                    selected: data[i].userId == userId,
                    userData: data[i],
                    userId: userId,
                  ),
            ],
          ),
        );
      },
    );
  }
}
