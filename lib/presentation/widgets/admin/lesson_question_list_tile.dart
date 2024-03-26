import 'package:flutter/material.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/pages/admin/edit_question_page.dart';

class LessonQuestionListTile extends StatelessWidget {
  const LessonQuestionListTile({
    super.key,
    required this.question,
  });

  final QuestionModel question;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 8),
        title: SizedBox(
          height: 50,
          child: Text(
            question.content,
            overflow: TextOverflow.clip,
          ),
        ),
        // subtitle: Text(question.lessonId),
        trailing: IconButton(
          onPressed: () => Navigator.pushNamed(
            context,
            EditQuestionPage.routeName,
            arguments: question,
          ),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
