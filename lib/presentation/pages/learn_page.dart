// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/presentation/viewmodel/lesson_viewmodel.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/presentation/widgets/lesson_list_tile.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:statsy/utils/is_waiting.dart';

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
        child: _lessons(context),
      ),
    );
  }

  Widget _lessons(BuildContext context) {
    return FutureBuilder(
      future: context.read<LessonViewmodel>().listLessons(),
      builder: (context, snapshot) {
        if (isWaiting(snapshot) || !snapshot.hasData) {
          return LinearProgressIndicator();
        }

        final lessons = snapshot.data!;

        return ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (context, index) => LessonListTile(
            lesson: lessons[index],
          ),
        );
      },
    );
  }
}
