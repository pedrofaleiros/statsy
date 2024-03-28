// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:statsy/presentation/widgets/lesson_level_list_item.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.orange,
        // foregroundColor: AppColors.black,
        title: const Text("Aprender"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [_lessonsCard()],
          ),
        ),
      ),
    );
  }

  Widget _lessonsCard() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: const [
          LessonLevelListItem(level: 1),
          LessonLevelListItem(level: 2),
          LessonLevelListItem(level: 3),
        ],
      ),
    );
  }
}
