import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/pages/answer/question_page.dart';
import 'package:statsy/presentation/viewmodel/alternative_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/game_viewmodel.dart';
import 'package:statsy/utils/app_colors.dart';

class AnswerQuestionPage extends StatefulWidget {
  const AnswerQuestionPage({super.key});

  static const routeName = '/answer-question';

  @override
  State<AnswerQuestionPage> createState() => _AnswerQuestionPageState();
}

class _AnswerQuestionPageState extends State<AnswerQuestionPage> {
  bool _isLoading = true;

  late final LessonModel lesson;
  late final QuestionModel? question;
  late final List<AlternativeModel>? alts;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) async => await _init());
  }

  Future<void> _init() async {
    final viewmodel = context.read<GameViewmodel>();

    lesson = ModalRoute.of(context)!.settings.arguments as LessonModel;
    question = viewmodel.pop();
    if (question != null) {
      alts = await context.read<AlternativeViewmodel>().list(question!.id);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _loading;
    return question == null || alts == null
        //TODO: CONCLUIR PAGE
        ? const Placeholder(
            child: Text('Concluir'),
          )
        : QuestionPage(
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
}
