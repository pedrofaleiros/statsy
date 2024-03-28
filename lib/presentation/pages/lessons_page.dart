// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/presentation/viewmodel/lesson_viewmodel.dart';
import 'package:statsy/presentation/widgets/lesson_list_tile.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  static const routeName = '/lesson';

  @override
  Widget build(BuildContext context) {
    final level = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: context.read<LessonViewmodel>().streamLessonByLevel(level),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return _loading;
              }
              final lessons = snapshot.data!;
              return _list(lessons);
            },
          ),
        ),
      ),
    );
  }

  Widget _list(List<LessonModel> lessons) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < lessons.length; i++)
            LessonListTile(lesson: lessons[i]),
        ],
      ),
    );
  }

  Widget get _loading => Column(
        children: [
          for (int i = 0; i < 3; i++)
            Card(
              margin: EdgeInsets.all(8),
              elevation: 4,
              child: SizedBox(height: 60, width: double.infinity),
            ),
        ],
      );
}
