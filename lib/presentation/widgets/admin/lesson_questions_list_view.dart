import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/pages/admin/edit_question_page.dart';
import 'package:statsy/presentation/viewmodel/question_viewmodel.dart';
import 'package:statsy/presentation/widgets/admin/lesson_question_list_tile.dart';
import 'package:uuid/uuid.dart';

class LessonQuestionsListView extends StatelessWidget {
  const LessonQuestionsListView({
    super.key,
    required this.lessonId,
  });

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<QuestionViewmodel>().streamQuestions(lessonId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Container();
        }
        final questions = snapshot.data!;
        return _listView(questions);
      },
    );
  }

  Widget _listView(List<QuestionModel> questions) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          ...questions.map((e) => LessonQuestionListTile(question: e)),
          AddQuestionButton(lessonId: lessonId)
        ],
      ),
    );
  }
}

class AddQuestionButton extends StatelessWidget {
  const AddQuestionButton({
    super.key,
    required this.lessonId,
  });

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => Navigator.pushNamed(
          context,
          EditQuestionPage.routeName,
          arguments: QuestionModel(
            id: const Uuid().v4(),
            content: '',
            lessonId: lessonId,
          ),
        ),
        child: const Text("Adicionar questão"),
      ),
    );
  }
}
