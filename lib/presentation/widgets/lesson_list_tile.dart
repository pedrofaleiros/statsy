// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/presentation/pages/answer/load_lesson_page.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';

class LessonListTile extends StatelessWidget {
  const LessonListTile({
    super.key,
    required this.lesson,
  });

  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Iniciar lição",
      showDuration: Duration(seconds: 1),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(lesson.name),
        subtitle: _randomPlaceholder,
        leading: Icon(Icons.school, color: getLevelColor(lesson.level)),
        trailing: const Icon(Icons.play_arrow),
        onTap: () => Navigator.pushNamed(
          context,
          LoadLessonPage.routeName,
          arguments: lesson,
        ),
      ),
    );
  }

  Widget get _randomPlaceholder {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${Random.secure().nextInt(5) + 1} questões"),
        Text("${Random.secure().nextInt(80) + 21}% completo"),
      ],
    );
  }
}
