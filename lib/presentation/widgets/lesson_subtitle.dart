import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/viewmodel/answer_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/question_viewmodel.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/utils/app_colors.dart';

class LessonSubtitle extends StatefulWidget {
  const LessonSubtitle({super.key, required this.lesson});

  final LessonModel lesson;

  @override
  State<LessonSubtitle> createState() => _LessonSubtitleState();
}

class _LessonSubtitleState extends State<LessonSubtitle> {
  List<QuestionModel>? questions;
  List<AnswerModel>? answers;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final aViewmodel = context.read<AnswerViewmodel>();
      final qViewmodel = context.read<QuestionViewmodel>();

      final questionsList = await qViewmodel.listQuestions(widget.lesson.id);

      List<AnswerModel> list = [];
      if (questionsList.isEmpty) {
        list = [];
        return;
      } else {
        for (var q in questionsList) {
          final ans = await aViewmodel.getAnswer(q.id);
          if (ans != null) list.add(ans);
        }
      }

      if (mounted) {
        setState(() {
          questions = questionsList;
          answers = list;
          loading = false;
        });
      }
    });
  }

  double _calculateProgress() {
    if (answers == null || questions == null) return 0;
    if (questions!.isEmpty) return 0;
    return answers!.length / questions!.length;
  }

  @override
  Widget build(BuildContext context) {
    if (loading || questions == null) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${questions!.length} questões"),
        _progress(context),
      ],
    );
  }

  Widget _progress(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          padding: const EdgeInsets.only(right: 8),
          child: LinearProgressIndicator(
            value: _calculateProgress(),
            borderRadius: BorderRadius.circular(100),
            color: getLevelColor(widget.lesson.level),
          ),
        ),
        Text(
          "${(_calculateProgress() * 100).toStringAsFixed(0)}%",
          style: const TextStyle(
            color: AppColors.grey,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
