import 'package:flutter/material.dart';
import 'package:statsy/presentation/pages/lessons_page.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/utils/app_colors.dart';

class LessonLevelListItem extends StatelessWidget {
  const LessonLevelListItem({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () => Navigator.pushNamed(
        context,
        LessonsPage.routeName,
        arguments: level,
      ),
      leading: Card(
        color: getLevelColor(level).withOpacity(0.75),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.school,
            color: AppColors.white,
          ),
        ),
      ),
      title: Text(getTitle(level)),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: AppColors.grey,
      ),
    );
  }
}

String getTitle(int level) {
  if (level == 1) {
    return "Iniciante";
  } else if (level == 2) {
    return "Intermediário";
  } else if (level == 3) {
    return "Avançado";
  } else if (level == 4) {
    return "Avançado";
  } else {
    return "Avançado";
  }
}
