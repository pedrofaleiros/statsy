// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:statsy/presentation/widgets/lesson_level_list_item.dart';
import 'package:statsy/utils/app_colors.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.black,
        title: const Text("Aprender"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _lessonsCard(),
          ],
        ),
      ),
    );
  }

  Widget _lessonsCard() {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          LessonLevelListItem(level: 1),
          _div,
          LessonLevelListItem(level: 2),
          _div,
          LessonLevelListItem(level: 3),
        ],
      ),
    );
  }

  Widget get _div => const Divider(height: 0, indent: 64 + 16);
}
