import 'package:flutter/material.dart';
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

  Future<void> _deleteQuestion() async {
    final viewmodel = context.read<QuestionViewmodel>();

    viewmodel.onSuccess = () {
      showMessageSnackBar(context: context, message: 'Deletado com sucesso');
      Navigator.pop(context);
    };

    await viewmodel.delete(question.id);
  }

  Future<void> _saveQuestion() async {
    final viewmodel = context.read<QuestionViewmodel>();

    viewmodel.onError = (message) => showMessageSnackBar(
          context: context,
          message: message,
        );
    viewmodel.onSuccess = () {
      showMessageSnackBar(context: context, message: 'Salvo com sucesso');
      // Navigator.pop(context);
      // FocusScope.of(context).unfocus();
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
        actions: [
          _saveButton(),
          _deleteButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _pageCard(),
              AlternativesListView(questionId: question.id)
            ],
          ),
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

  Widget _deleteButton() {
    return IconButton(
      onPressed: _deleteQuestion,
      icon: const Icon(Icons.delete),
    );
  }

  Widget _pageCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: TextField(
          maxLines: 5,
          textInputAction: TextInputAction.done,
          onChanged: (value) => question = question.copyWith(content: value),
          controller: contentController,
          decoration: const InputDecoration(
            hintText: "Conteúdo",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class AlternativesListView extends StatelessWidget {
  const AlternativesListView({super.key, required this.questionId});

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
        return _altsListView(context, alternatives);
      },
    );
  }

  Widget _altsListView(
    BuildContext context,
    List<AlternativeModel> alternatives,
  ) {
    return Column(
      children: [
        ...alternatives.map((e) => QuestionAlternativeListTile(alternative: e)),
        _textField(context),
        // AddAlternativeButton(questionId: questionId),
        // _addAltButton(),
      ],
    );
  }

  Padding _textField(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onEditingComplete: () async => await _addAlt(context, controller),
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () async => await _addAlt(context, controller),
            icon: const Icon(Icons.add),
          ),
          hintText: 'Text',
        ),
      ),
    );
  }

  Future<void> _addAlt(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final newAlt = AlternativeModel(
      id: const Uuid().v4(),
      text: controller.text,
      isCorrect: false,
      questionId: questionId,
    );
    final viewmodel = context.read<AlternativeViewmodel>();

    viewmodel.onError = (message) {
      showMessageSnackBar(context: context, message: message);
    };

    viewmodel.onSuccess = () {
      controller.clear();
      FocusScope.of(context).unfocus();
    };

    await viewmodel.save(newAlt);
  }
}
