import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/pages/answer/load_question_page.dart';
import 'package:statsy/presentation/viewmodel/answer_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/question_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/user_data_viewmodel.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:statsy/utils/is_waiting.dart';

class FinishPage extends StatefulWidget {
  const FinishPage({
    super.key,
    required this.lesson,
  });

  final LessonModel lesson;

  @override
  State<FinishPage> createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final qViewmodel = context.read<QuestionViewmodel>();
      final udViewmodel = context.read<UserDataViewmodel>();
      final questions = await qViewmodel.listQuestions(widget.lesson.id);
      final complete = await isLessonComplete(questions);
      if (complete) await udViewmodel.levelUp(widget.lesson.level + 1);
    });
  }

  Future<bool> isLessonComplete(List<QuestionModel> questions) async {
    final aViewmodel = context.read<AnswerViewmodel>();
    for (var q in questions) {
      final ans = await aViewmodel.getAnswer(q.id);
      if (ans == null) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        leading: Container(),
        title: Text(widget.lesson.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: context
                  .read<QuestionViewmodel>()
                  .listQuestions(widget.lesson.id),
              builder: (context, snapshot) {
                if (isWaiting(snapshot) || !snapshot.hasData) {
                  return Container();
                }

                List<QuestionModel> questions = snapshot.data!;
                return ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) =>
                      AnseredQuestionListTile(question: questions[index]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: CupertinoButton(
              color: AppColors.blue,
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Finalizar",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.black
                      : AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
