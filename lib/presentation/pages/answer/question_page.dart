import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/pages/answer/answer_question_page.dart';
import 'package:statsy/presentation/viewmodel/answer_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/game_viewmodel.dart';
import 'package:statsy/presentation/widgets/aura_widget.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/presentation/widgets/show_correct_answer.dart';
import 'package:statsy/presentation/widgets/show_wrong_answer.dart';
import 'package:statsy/utils/app_colors.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({
    super.key,
    required this.lesson,
    required this.question,
    required this.alts,
  });

  final LessonModel lesson;
  final QuestionModel question;
  final List<AlternativeModel> alts;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String selectedId = "";

  Future<void> _answer() async {
    final viewmodel = context.read<AnswerViewmodel>();

    final alt = widget.alts.firstWhere((element) => element.id == selectedId);

    viewmodel.onCorrect = () {
      showCorrectAnswer(context, "Acertou!").then((value) {
        Navigator.pushReplacementNamed(
          context,
          AnswerQuestionPage.routeName,
          arguments: widget.lesson,
        );
      });
    };

    viewmodel.onWrong = () {
      showWrongAnswer(context, "Resposta incorreta").then((value) {
        Navigator.pushReplacementNamed(
          context,
          AnswerQuestionPage.routeName,
          arguments: widget.lesson,
        );
      });
    };

    await viewmodel.testAnswer(alt);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<GameViewmodel>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        title: LinearProgressIndicator(
          color: getLevelColor(widget.lesson.level),
          value: (vm.total - vm.questions.length) / vm.total,
          borderRadius: BorderRadius.circular(8),
          minHeight: 12,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const AuraWidget(size: 32),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _questionContent,
                    const SizedBox(height: 32),
                    ...widget.alts.map(
                      (e) => _alternativeListTile(e),
                    ),
                  ],
                ),
              ),
              _answerButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget _alternativeListTile(AlternativeModel alt) {
    final isSelected = selectedId == alt.id;
    return Card(
      child: ListTile(
        onTap: () => setState(() => selectedId = alt.id),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        selectedTileColor: getLevelColor(widget.lesson.level).withOpacity(0.1),
        selectedColor: getLevelColor(widget.lesson.level),
        selected: isSelected,
        title: Text(
          alt.text,
          style: TextStyle(fontWeight: isSelected ? FontWeight.bold : null),
        ),
        leading: Icon(
          isSelected
              ? Icons.radio_button_checked
              : Icons.radio_button_unchecked,
        ),
      ),
    );
  }

  Widget get _questionContent {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.question.content,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget get _answerButton {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        color: getLevelColor(widget.lesson.level),
        onPressed: selectedId == "" ? null : () async => await _answer(),
        child: Text(
          "Responder",
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
