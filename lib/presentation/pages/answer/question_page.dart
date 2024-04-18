import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/pages/answer/load_question_page.dart';
import 'package:statsy/presentation/viewmodel/answer_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/tutor_viewmodel.dart';
import 'package:statsy/presentation/widgets/alternative_list_tile.dart';
import 'package:statsy/presentation/widgets/get_level_color.dart';
import 'package:statsy/presentation/widgets/question_app_bar.dart';
import 'package:statsy/presentation/widgets/question_content.dart';
import 'package:statsy/presentation/widgets/question_image.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _load(widget.question.id),
    );
  }

  Future<void> _answer() async {
    final viewmodel = context.read<AnswerViewmodel>();

    final alt = widget.alts.firstWhere((element) => element.id == selectedId);
    final correct = widget.alts.firstWhere((element) => element.isCorrect);

    viewmodel.onCorrect = () {
      showCorrectAnswer(context, "Acertou!", widget.question.id)
          .then((value) => _next());
    };

    viewmodel.onWrong = () {
      showWrongAnswer(
        context,
        "Resposta incorreta",
        correct.text,
        widget.question.id,
      ).then((value) => _next());
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

  String? image;

  Future<void> _load(String id) async {
    if (widget.question.hasImage != null && !widget.question.hasImage!) {
      return;
    }

    try {
      final storage = FirebaseStorage.instance.ref();
      final pathReference = storage.child("question/$id.png");
      final data = await pathReference.getDownloadURL();
      setState(() => image = data);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<TutorViewmodel>().clear();
    return Scaffold(
      appBar: questionAppBar(
        context,
        getLevelColor(widget.lesson.level),
        // _helpButton(),
        null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    QuestionContent(content: widget.question.content),
                    QuestionImage(image: image),
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
