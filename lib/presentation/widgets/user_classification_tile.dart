import 'package:flutter/material.dart';
import 'package:statsy/domain/models/user_data_model.dart';
import 'package:statsy/presentation/widgets/app_bar_title.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/utils/app_colors.dart';

class UserClassificationTile extends StatelessWidget {
  const UserClassificationTile({
    super.key,
    required this.userData,
    required this.userId,
    this.selected,
  });

  final String userId;
  final UserDataModel userData;
  final bool? selected;

  Color getSelectedColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return AppColors.black.withOpacity(0.25);
    }
    return AppColors.grey6;
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = selected != null && selected!;
    return ListTile(
      tileColor: isSelected ? getSelectedColor(context) : null,
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
