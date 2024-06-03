import 'package:flutter/material.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/utils/app_colors.dart';

class QuestionsProgress extends StatelessWidget {
  const QuestionsProgress({
    super.key,
    required this.answers,
    required this.questions,
  });

  final List<AnswerModel> answers;
  final List<QuestionModel> questions;

  @override
  Widget build(BuildContext context) {
    return questions.isEmpty
        ? Container()
        : ListTile(
            title: Text(
                'Progresso: ${(answers.length / questions.length * 100).toStringAsFixed(0)}% (${answers.length} de ${questions.length} questões)'),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(
                minHeight: 12,
                borderRadius: BorderRadius.circular(100),
                value: answers.length / questions.length,
                color: AppColors.mint,
              ),
            ),
          );
  }
}
