import 'package:flutter/material.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/presentation/pages/admin/edit_lesson_page.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:statsy/utils/is_admin.dart';

class LessonListTile extends StatelessWidget {
  const LessonListTile({
    super.key,
    required this.lesson,
  });

  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        if (isAdmin()) {
          Navigator.pushNamed(
            context,
            EditLessonPage.routeName,
            arguments: lesson,
          );
        }
      },
      leading: Card(
        color: getLevelColor(lesson.level),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.school,
            color: AppColors.white,
          ),
        ),
      ),
      title: Text(lesson.name),
      subtitle: Text(lesson.description),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.play_arrow),
      ),
    );
  }
}

Color getLevelColor(int level) {
  if (level == 1) {
    return AppColors.blue;
  } else if (level == 2) {
    return AppColors.green;
  } else if (level == 3) {
    return AppColors.yellow;
  } else if (level == 4) {
    return AppColors.orange;
  } else {
    return AppColors.red;
  }
}
