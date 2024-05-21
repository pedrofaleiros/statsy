import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:statsy/presentation/widgets/question_image.dart';
import 'package:statsy/utils/app_colors.dart';

class ViewQuestionPage extends StatefulWidget {
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

  @override
  State<ViewQuestionPage> createState() => _ViewQuestionPageState();
}

class _ViewQuestionPageState extends State<ViewQuestionPage> {
  // bool get isAnswerCorrect {
  //   for (var alt in widget.alts) {
  //     if (alt.id == widget.answer.alternativeId) {
  //       return alt.isCorrect;
  //     }
  //   }
  //   return false;
  // }

  String get correctId {
    for (var alt in widget.alts) {
      if (alt.isCorrect) {
        return alt.id;
      }
    }
    return "";
  }

  String? image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadImage(widget.question.id);
    });
  }

  void _loadImage(String id) async {
    try {
      final storage = FirebaseStorage.instance.ref();
      final pathReference = storage.child("resolution/res$id.png");
      final data = await pathReference.getDownloadURL();
      setState(() => image = data);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: questionAppBar(context, getLevelColor(widget.lesson.level), null),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              QuestionContent(content: widget.question.content),
              const SizedBox(height: 16),
              ..._alternativesList,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: QuestionImage(image: image),
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
        leading: widget.answer.isCorrect
            ? const Icon(Icons.check_circle, color: AppColors.green)
            : const Icon(Icons.close, color: AppColors.red),
        title: widget.answer.isCorrect
            ? const Text('Você acertou essa questão.')
            : const Text('Você respondeu incorretamente essa questão.'),
      ),
    );
  }

  Iterable<Widget> get _alternativesList {
    if (widget.answer.isCorrect) {
      return widget.alts.map(
        (alt) => AlternativeListTile(
          isSelected: widget.answer.alternativeId == alt.id,
          alternative: alt,
          onTap: (id) {},
          color: AppColors.green,
        ),
      );
    }

    return widget.alts.map(
      (alt) => AlternativeListTile(
        isSelected:
            widget.answer.alternativeId == alt.id || correctId == alt.id,
        alternative: alt,
        onTap: (id) {},
        color: correctId == alt.id ? AppColors.green : AppColors.red,
      ),
    );
  }

  void _next(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      LoadQuestionPage.routeName,
      arguments: widget.lesson,
    );
  }

  Widget _nextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        color: getLevelColor(widget.lesson.level),
        onPressed: () => _next(context),
        child: Text(
          "Continuar",
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
