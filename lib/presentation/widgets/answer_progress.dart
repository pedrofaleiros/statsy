import 'package:flutter/material.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/utils/app_colors.dart';

class AnswerProgress extends StatelessWidget {
  const AnswerProgress({
    super.key,
    required this.answers,
  });

  final List<AnswerModel> answers;

  @override
  Widget build(BuildContext context) {
    var correct = 0;
    for (var ans in answers) {
      if (ans.isCorrect) correct++;
    }

    return answers.isEmpty
        ? Container()
        : ListTile(
            title: Text(
                'Taxa de acertos: ${(correct / answers.length * 100).toStringAsFixed(0)}% ($correct de ${answers.length} questões)'),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(
                minHeight: 12,
                borderRadius: BorderRadius.circular(100),
                value: correct / answers.length,
                color: AppColors.indigo,
              ),
            ),
          );
  }
}
