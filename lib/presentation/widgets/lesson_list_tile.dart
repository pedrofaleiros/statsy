// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/presentation/pages/answer/load_lesson_page.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/utils/app_colors.dart';

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
        onTap: () => Navigator.pushNamed(
          context,
          LoadLessonPage.routeName,
          arguments: lesson,
        ),
        leading: _leading(lesson),
        title: _title(lesson),
        subtitle: _randomPlaceholder,
        trailing: const Icon(Icons.play_arrow),
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

  Card _leading(LessonModel lesson) {
    return Card(
      color: getLevelColor(lesson.level),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.school,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget get _randomPlaceholder {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text("${Random.secure().nextInt(5) + 1} questões"),
        Text("${Random.secure().nextInt(80) + 21}% completo"),
      ],
    );
  }
}
