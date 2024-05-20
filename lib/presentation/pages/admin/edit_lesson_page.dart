import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/presentation/viewmodel/lesson_viewmodel.dart';
import 'package:statsy/presentation/widgets/admin/lesson_questions_list_view.dart';
import 'package:statsy/presentation/widgets/admin/lesson_text_field.dart';
import 'package:statsy/presentation/widgets/show_message_snackbar.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:uuid/uuid.dart';

class EditLessonPage extends StatefulWidget {
  const EditLessonPage({super.key});

  static const routeName = '/edit-lesson';

  @override
  State<EditLessonPage> createState() => _EditLessonPageState();
}

class _EditLessonPageState extends State<EditLessonPage> {
  late LessonModel lesson;
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final pointsController = TextEditingController();
  final levelController = TextEditingController();

  void _getLesson() {
    lesson = ModalRoute.of(context)!.settings.arguments as LessonModel? ??
        LessonModel(
          id: const Uuid().v4(),
          name: "",
          description: "",
          level: 0,
          points: 0,
        );
  }

  Future<void> _saveLesson() async {
    final viewmodel = context.read<LessonViewmodel>();
    viewmodel.onError = (message) => showMessageSnackBar(
          context: context,
          message: message,
        );
    viewmodel.onSuccess = () {
      showMessageSnackBar(context: context, message: 'Salvo com sucesso');
      Navigator.pop(context);
    };

    await viewmodel.saveLesson(lesson);
  }

  Future<void> _deleteLesson() async {
    final viewmodel = context.read<LessonViewmodel>();

    viewmodel.onSuccess = () {
      showMessageSnackBar(context: context, message: 'Deletado com sucesso');
      Navigator.pop(context);
    };

    await viewmodel.delete(lesson.id);
  }

  @override
  Widget build(BuildContext context) {
    _getLesson();

    nameController.text = lesson.name;
    descController.text = lesson.description;
    levelController.text = lesson.level == 0 ? '' : lesson.level.toString();
    pointsController.text = lesson.points == 0 ? '' : lesson.points.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        title: const Text('Editar lição'),
        centerTitle: true,
        actions: [
          _saveButton(),
          _deleteButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(lesson.id),
            ),
            _firstCard(),
            _secondCard(),
            LessonQuestionsListView(lessonId: lesson.id),
          ],
        ),
      ),
    );
  }

  Widget _secondCard() {
    return _pageCard(
      child: Column(
        children: [
          LessonTextField(
            name: "Nivel",
            cont: levelController,
            onChanged: (value) => lesson = lesson.copyWith(
              level: int.tryParse(value),
            ),
          ),
          const Divider(height: 0),
          LessonTextField(
            name: "Pontos",
            cont: pointsController,
            onChanged: (value) => lesson = lesson.copyWith(
              points: int.tryParse(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _firstCard() {
    return _pageCard(
      child: Column(
        children: [
          _nameTextField(),
          const Divider(height: 0),
          _descTextField(),
        ],
      ),
    );
  }

  Widget _nameTextField() {
    return TextField(
      textInputAction: TextInputAction.next,
      onChanged: (value) => lesson = lesson.copyWith(name: value),
      controller: nameController,
      decoration: const InputDecoration(
        hintText: "Nome",
        border: InputBorder.none,
      ),
    );
  }

  Widget _descTextField() {
    return TextField(
      textInputAction: TextInputAction.next,
      onChanged: (value) => lesson = lesson.copyWith(description: value),
      controller: descController,
      decoration: const InputDecoration(
        hintText: "Descrição",
        border: InputBorder.none,
      ),
    );
  }

  Widget _saveButton() {
    return IconButton(
      onPressed: _saveLesson,
      icon: const Icon(Icons.save),
    );
  }

  Widget _deleteButton() {
    return IconButton(
      onPressed: _deleteLesson,
      icon: const Icon(Icons.delete),
    );
  }

  Widget _pageCard({required Widget child}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: child,
      ),
    );
  }
}
