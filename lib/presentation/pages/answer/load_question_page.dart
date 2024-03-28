import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/models/answer_model.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/pages/answer/question_page.dart';
import 'package:statsy/presentation/pages/answer/view_question_page.dart';
import 'package:statsy/presentation/viewmodel/alternative_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/answer_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/game_viewmodel.dart';
import 'package:statsy/utils/app_colors.dart';

class LoadQuestionPage extends StatefulWidget {
  const LoadQuestionPage({super.key});

  static const routeName = '/answer-question';

  @override
  State<LoadQuestionPage> createState() => LoadQuestionPageState();
}

class LoadQuestionPageState extends State<LoadQuestionPage> {
  bool _isLoading = true;

  late final LessonModel lesson;
  late final QuestionModel? question;
  late final List<AlternativeModel>? alts;
  late final AnswerModel? answer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) async => await _init());
  }

  Future<void> _init() async {
    final viewmodel = context.read<GameViewmodel>();
    final answerVm = context.read<AnswerViewmodel>();

    lesson = ModalRoute.of(context)!.settings.arguments as LessonModel;
    question = viewmodel.pop();
    if (question != null) {
      alts = await context.read<AlternativeViewmodel>().list(question!.id);
      answer = await answerVm.getAnswer(question!.id);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _loading;

    if (question == null || alts == null) {
      return _finishPage;
    }

    if (answer != null) {
      return ViewQuestionPage(
        lesson: lesson,
        question: question!,
        alts: alts!,
        answer: answer!,
      );
    }

    return QuestionPage(
      lesson: lesson,
      question: question!,
      alts: alts!,
    );
  }

  Widget get _loading {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.mint),
        ),
      ),
    );
  }

  Widget get _finishPage {
    //TODO: concluir
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: Container(),
        title: const Text('Concluir'),
      ),
    );
  }
}
