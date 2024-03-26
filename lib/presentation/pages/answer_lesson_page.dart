import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/presentation/viewmodel/game_viewmodel.dart';

class AnswerLessonPage extends StatelessWidget {
  const AnswerLessonPage({super.key});

  static const routeName = "/answer-lesson";

  @override
  Widget build(BuildContext context) {
    final lesson = ModalRoute.of(context)!.settings.arguments as LessonModel;

    return FutureBuilder(
      future: context.read<GameViewmodel>().getQuestions(lesson.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return PageView(
          children: [],
        );
      },
    );
  }
}
