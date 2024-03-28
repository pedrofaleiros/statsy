import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/presentation/pages/answer/answer_question_page.dart';
import 'package:statsy/presentation/viewmodel/game_viewmodel.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
import 'package:statsy/utils/app_colors.dart';

class LoadLessonPage extends StatefulWidget {
  const LoadLessonPage({super.key});

  static const routeName = "/load-lesson";

  @override
  State<LoadLessonPage> createState() => _LoadLessonPageState();
}

class _LoadLessonPageState extends State<LoadLessonPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => _loadQuestions(),
    );
  }

  Future<void> _loadQuestions() async {
    final lesson = ModalRoute.of(context)!.settings.arguments as LessonModel;
    final viewmodel = context.read<GameViewmodel>();

    viewmodel.onSuccess = () {
      Navigator.pushReplacementNamed(
        context,
        AnswerQuestionPage.routeName,
        arguments: lesson,
      );
    };

    viewmodel.onError = (message) {
      Navigator.pop(context);
      showMessageSnackBar(
          context: context, message: message ?? "Erro ao iniciar lição");
    };

    await viewmodel.loadQuestions(lesson.id);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.mint),
        ),
      ),
    );
  }
}
