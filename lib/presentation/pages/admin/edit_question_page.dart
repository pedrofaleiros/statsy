// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/presentation/viewmodel/alternative_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/question_viewmodel.dart';
import 'package:statsy/presentation/widgets/admin/question_alternative_list_tile.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:uuid/uuid.dart';

class EditQuestionPage extends StatefulWidget {
  const EditQuestionPage({super.key});

  static const routeName = '/edit-question';

  @override
  State<EditQuestionPage> createState() => _EditLessoQuestiontate();
}

class _EditLessoQuestiontate extends State<EditQuestionPage> {
  late QuestionModel question;
  final contentController = TextEditingController();

  void _getQuestion() {
    question = ModalRoute.of(context)!.settings.arguments as QuestionModel;
  }

  Future<void> _saveQuestion() async {
    final viewmodel = context.read<QuestionViewmodel>();

    viewmodel.onError = (message) => showMessageSnackBar(
          context: context,
          message: message,
        );
    viewmodel.onSuccess = () {
      showMessageSnackBar(context: context, message: 'Salvo com sucesso');
      Navigator.pop(context);
    };

    await viewmodel.saveQuestion(question);
  }

  @override
  Widget build(BuildContext context) {
    _getQuestion();

    contentController.text = question.content;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        title: const Text('Editar questão'),
        centerTitle: true,
        actions: [_saveButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            _pageCard(),
            AlternativesListView(questionId: question.id)
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return IconButton(
      onPressed: _saveQuestion,
      icon: const Icon(Icons.save),
    );
  }

  Widget _pageCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: TextField(
          textInputAction: TextInputAction.done,
          onChanged: (value) => question = question.copyWith(content: value),
          controller: contentController,
          decoration: const InputDecoration(
            hintText: "Nome",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class AlternativesListView extends StatelessWidget {
  const AlternativesListView({
    super.key,
    required this.questionId,
  });

  final String questionId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AlternativeViewmodel>().stream(questionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Container();
        }

        final alternatives = snapshot.data!;
        return _altsListView(alternatives);
      },
    );
  }

  Widget _altsListView(List<AlternativeModel> alternatives) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          ...alternatives
              .map((e) => QuestionAlternativeListTile(alternative: e)),
          AddAlternativeButton(questionId: questionId),
        ],
      ),
    );
  }
}

class AddAlternativeButton extends StatelessWidget {
  const AddAlternativeButton({
    super.key,
    required this.questionId,
  });

  final String questionId;

  Future<void> _addAlt(BuildContext context) async {
    final newAlt = AlternativeModel(
      id: const Uuid().v4(),
      text: "Texto",
      isCorrect: false,
      questionId: questionId,
    );
    final viewmodel = context.read<AlternativeViewmodel>();

    viewmodel.onError = (message) {
      showMessageSnackBar(context: context, message: message);
    };

    await viewmodel.save(newAlt);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () async => await _addAlt(context),
        child: const Text("Adicionar alternativa"),
      ),
    );
  }
}
