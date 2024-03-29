import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/pages/answer/load_question_page.dart';
import 'package:statsy/presentation/viewmodel/answer_viewmodel.dart';
import 'package:statsy/presentation/widgets/alternative_list_tile.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/presentation/widgets/question_app_bar.dart';
import 'package:statsy/presentation/widgets/question_content.dart';
import 'package:statsy/presentation/widgets/show_correct_answer.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
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
      showCorrectAnswer(context, "Acertou!").then((value) => _next());
    };

    viewmodel.onWrong = () {
      showWrongAnswer(context, "Resposta incorreta").then((value) => _next());
    };

    viewmodel.onError = (message) {
      showMessageSnackBar(context: context, message: message ?? "Erro");
    };

    //TODO: answer
    await viewmodel.testAnswer(alt);
  }

  void _next() {
    Navigator.pushReplacementNamed(
      context,
      LoadQuestionPage.routeName,
      arguments: widget.lesson,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: questionAppBar(context, getLevelColor(widget.lesson.level)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    QuestionContent(content: widget.question.content),
                    const SizedBox(height: 16),
                    ..._alternativesList,
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

  Iterable<Widget> get _alternativesList {
    return widget.alts.map(
      (alt) => AlternativeListTile(
        isSelected: selectedId == alt.id,
        alternative: alt,
        onTap: (id) => setState(() => selectedId = id),
        color: getLevelColor(widget.lesson.level),
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
