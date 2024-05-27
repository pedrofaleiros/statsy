import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/viewmodel/answer_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/question_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/user_data_viewmodel.dart';
import 'package:statsy/presentation/widgets/answer_progress.dart';
import 'package:statsy/presentation/widgets/app_bar_title.dart';
import 'package:statsy/presentation/widgets/app_logo.dart';
import 'package:statsy/presentation/widgets/classification_list.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/presentation/widgets/question_progress.dart';
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await context.read<AnswerViewmodel>().listUserAnswers().then(
          (data) async {
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: loading
          ? Container()
          : Column(
              children: [
                const ListTile(title: AppBarTitle(text: 'Progresso')),
                QuestionsProgress(
                  answers: answers ?? [],
                  questions: questions ?? [],
                ),
                AnswerProgress(answers: answers ?? []),
                const UserDataProgress(),
                const SizedBox(height: 32),
                const ClassificationList()
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
