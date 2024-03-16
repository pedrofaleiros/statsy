import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/presentation/pages/admin/edit_lesson_page.dart';
import 'package:statsy/presentation/viewmodel/lesson_viewmodel.dart';
import 'package:statsy/presentation/widgets/lesson_list_tile.dart';
import 'package:statsy/utils/app_colors.dart';
import 'package:statsy/utils/is_admin.dart';

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppColors.orange,
        foregroundColor: AppColors.orange,
        title: const Text(
          'Lições',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          if (isAdmin())
            IconButton(
              onPressed: () => Navigator.pushNamed(
                context,
                EditLessonPage.routeName,
                arguments: null,
              ),
              icon: const Icon(Icons.add),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: context.read<LessonViewmodel>().lessons,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const LinearProgressIndicator(color: AppColors.blue);
            }

            final lessons = snapshot.data!;
            return _lessonsListView(lessons);
          },
        ),
      ),
    );
  }

  Widget _lessonsListView(List<LessonModel> lessons) {
    return Column(
      children: [
        ...lessons.map((e) => LessonListTile(lesson: e)),
      ],
    );
  }
}
