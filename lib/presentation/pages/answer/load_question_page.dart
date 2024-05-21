import 'package:flutter/cupertino.dart';
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
import 'package:statsy/presentation/viewmodel/question_viewmodel.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:statsy/utils/is_waiting.dart';

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

    if (mounted) {
      setState(() => _isLoading = false);
    }
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        leading: Container(),
        title: Text(lesson.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future:
                  context.read<QuestionViewmodel>().listQuestions(lesson.id),
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

class AnseredQuestionListTile extends StatefulWidget {
  const AnseredQuestionListTile({
    super.key,
    required this.question,
  });

  final QuestionModel question;

  @override
  State<AnseredQuestionListTile> createState() =>
      _AnseredQuestionListTileState();
}

class _AnseredQuestionListTileState extends State<AnseredQuestionListTile> {
  AnswerModel? answer;
  List<AlternativeModel> alternatives = [];

  Future<void> _loadData() async {
    await context
        .read<AnswerViewmodel>()
        .getAnswer(widget.question.id)
        .then((data) async {
      answer = data;
      alternatives =
          await context.read<AlternativeViewmodel>().list(widget.question.id);
    });

    setState(() {});
  }

  String getCorrectId() {
    for (var alt in alternatives) {
      if (alt.isCorrect) return alt.id;
    }
    return "";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) async => _loadData());
  }

  bool expand = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () => setState(() => expand = !expand),
        contentPadding: const EdgeInsets.only(right: 8, left: 16),
        title: Text(
          '"${widget.question.content}"',
          overflow: expand ? null : TextOverflow.ellipsis,
        ),
        subtitle: answer != null && answer!.isCorrect
            ? const Text(
                "Você acertou!",
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        trailing: answer == null
            ? null
            : answer != null && answer!.isCorrect
                ? const Icon(Icons.check, color: AppColors.green)
                : const Icon(Icons.close, color: AppColors.red),
      ),
    );
  }
}
