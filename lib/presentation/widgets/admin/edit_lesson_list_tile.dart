import 'package:flutter/material.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/presentation/pages/admin/edit_lesson_page.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:statsy/utils/is_admin.dart';

class EditLessonListTile extends StatelessWidget {
  const EditLessonListTile({
    super.key,
    required this.lesson,
  });

  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        onPressed: () {
          if (isAdmin()) {
            Navigator.pushNamed(
              context,
              EditLessonPage.routeName,
              arguments: lesson,
            );
          }
        },
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
