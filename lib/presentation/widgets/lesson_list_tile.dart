import 'package:flutter/material.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/models/user_data_model.dart';
import 'package:statsy/presentation/pages/answer/load_lesson_page.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/presentation/widgets/lesson_subtitle.dart';
import 'package:statsy/utils/app_colors.dart';

class LessonListTile extends StatefulWidget {
  const LessonListTile({
    super.key,
    required this.lesson,
    required this.userData,
  });

  final LessonModel lesson;
  final UserDataModel userData;

  @override
  State<LessonListTile> createState() => _LessonListTileState();
}

class _LessonListTileState extends State<LessonListTile> {
  bool get canAccess {
    return widget.userData.level >= widget.lesson.level;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: canAccess ? 1 : 0,
      child: Tooltip(
        message: canAccess ? "Iniciar lição" : "",
        showDuration: const Duration(seconds: 1),
        child: ListTile(
          onTap: !canAccess
              ? null
              : () => Navigator.pushNamed(
                    context,
                    LoadLessonPage.routeName,
                    arguments: widget.lesson,
                  ),
          leading: _leading(widget.lesson),
          title: _title(widget.lesson),
          subtitle: !canAccess ? null : LessonSubtitle(lesson: widget.lesson),
          trailing: !canAccess
              ? const Icon(
                  Icons.lock_rounded,
                  color: AppColors.grey,
                )
              : const Icon(Icons.play_arrow_rounded),
        ),
      ),
    );
  }

  Widget _title(LessonModel lesson) {
    return Text(
      lesson.name,
      style: TextStyle(
        color: getLevelColor(lesson.level),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _leading(LessonModel lesson) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Icon(
        Icons.school_rounded,
        color: getLevelColor(lesson.level),
      ),
    );
  }
}
