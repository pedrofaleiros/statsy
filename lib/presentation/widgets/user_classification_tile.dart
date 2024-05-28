import 'package:flutter/material.dart';
import 'package:statsy/domain/models/user_data_model.dart';
import 'package:statsy/presentation/widgets/app_bar_title.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';

class UserClassificationTile extends StatelessWidget {
  const UserClassificationTile({
    super.key,
    required this.userData,
    required this.userId,
  });

  final String userId;
  final UserDataModel userData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${userData.username} ${userId == userData.userId ? "(Você)" : ""}",
        style: TextStyle(
          fontWeight: userId == userData.userId ? FontWeight.bold : null,
        ),
      ),
      trailing: Text("${userData.points}"),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: AppBarTitle(
          text: "${userData.level}",
          color: getLevelColor(userData.level),
        ),
      ),
    );
  }
}
