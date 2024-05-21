// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/viewmodel/answer_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/question_viewmodel.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:statsy/utils/is_waiting.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  static const routeName = "/progress";

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<AnswerModel>? answers;
  List<QuestionModel>? questions;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context
          .read<AnswerViewmodel>()
          .listUserAnswers()
          .then((data) async {
        setState(() {
          answers = data;
        });

        await context
            .read<QuestionViewmodel>()
            .listAllQuestions()
            .then(
              (value) => setState(() => questions = value),
            )
            .then((value) => setState(() => loading = false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.black,
        title: const Text('Progresso'),
      ),
      body: loading
          ? Container()
          : Column(
              children: [
                QuestionsProgressWidget(
                  answers: answers ?? [],
                  questions: questions ?? [],
                ),
                AnswerProgressWidget(
                  answers: answers ?? [],
                ),
              ],
            ),
    );
  }
}

class AnswerProgressWidget extends StatelessWidget {
  const AnswerProgressWidget({
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
        : Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            elevation: 4,
            child: ListTile(
              title: Text(
                  'Taxa de acertos: ${(correct / answers.length * 100).toStringAsFixed(0)}% ($correct de ${answers.length} questões)'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(100),
                  value: correct / answers.length,
                  color: AppColors.blue,
                ),
              ),
            ),
          );
  }
}

class QuestionsProgressWidget extends StatelessWidget {
  const QuestionsProgressWidget({
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
        : Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            elevation: 4,
            child: ListTile(
              title: Text(
                  'Progresso: ${(answers.length / questions.length * 100).toStringAsFixed(0)}% (${answers.length} de ${questions.length} questões)'),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(100),
                  value: answers.length / questions.length,
                  color: AppColors.green,
                ),
              ),
            ),
          );
  }
}
