import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/pages/answer/load_question_page.dart';
import 'package:statsy/presentation/widgets/alternative_list_tile.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/presentation/widgets/question_app_bar.dart';
import 'package:statsy/presentation/widgets/question_content.dart';
import 'package:statsy/utils/app_colors.dart';

class ViewQuestionPage extends StatelessWidget {
  const ViewQuestionPage({
    super.key,
    required this.lesson,
    required this.question,
    required this.alts,
    required this.answer,
  });

  final LessonModel lesson;
  final QuestionModel question;
  final List<AlternativeModel> alts;
  final AnswerModel answer;

  bool get isAnswerCorrect {
    for (var alt in alts) {
      if (alt.id == answer.alternativeId) {
        return alt.isCorrect;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: questionAppBar(context, getLevelColor(lesson.level)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    QuestionContent(content: question.content),
                    const SizedBox(height: 16),
                    ..._alternativesList,
                  ],
                ),
              ),
              _message,
              _nextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _message {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: ListTile(
        leading: isAnswerCorrect
            ? const Icon(Icons.check_circle, color: AppColors.green)
            : const Icon(Icons.close, color: AppColors.red),
        title: isAnswerCorrect
            ? const Text('Você acertou essa questão.')
            : const Text('Você respondeu incorretamente essa questão.'),
      ),
    );
  }

  Iterable<Widget> get _alternativesList {
    return alts.map(
      (alt) => AlternativeListTile(
        isSelected: answer.alternativeId == alt.id,
        alternative: alt,
        onTap: (id) {},
        color: isAnswerCorrect ? AppColors.green : AppColors.red,
      ),
    );
  }

  void _next(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      LoadQuestionPage.routeName,
      arguments: lesson,
    );
  }

  Widget _nextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        color: getLevelColor(lesson.level),
        onPressed: () => _next(context),
        child: Text(
          "Prosseguir",
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
    );
  }
}
