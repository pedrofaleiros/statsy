import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/viewmodel/answer_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/question_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/user_data_viewmodel.dart';
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
                const SizedBox(height: 4),
                const UserDataProgress(),
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

class UserDataProgress extends StatelessWidget {
  const UserDataProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<UserDataViewmodel>().getUserData(),
      builder: (context, snapshot) {
        if (isWaiting(snapshot) || !snapshot.hasData) {
          return Container();
        }

        final data = snapshot.data!;
        return Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: const Text('Nivel'),
                trailing: Text(
                  '${data.level}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: const Text('Pontos'),
                trailing: Text(
                  '${data.points}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
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
