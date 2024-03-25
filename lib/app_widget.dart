import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/pages/admin/edit_lesson_page.dart';
import 'package:statsy/presentation/pages/admin/edit_question_page.dart';
import 'package:statsy/presentation/pages/admin/edit_lessons_page.dart';
import 'package:statsy/presentation/pages/splash_page.dart';
import 'package:statsy/presentation/viewmodel/alternative_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/lesson_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/question_viewmodel.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewmodel>(
          create: (context) => AuthViewmodel(),
        ),
        Provider<LessonViewmodel>(create: (context) => LessonViewmodel()),
        Provider<QuestionViewmodel>(create: (context) => QuestionViewmodel()),
        Provider<AlternativeViewmodel>(
          create: (context) => AlternativeViewmodel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        routes: _routes,
      ),
    );
  }

  Map<String, WidgetBuilder> get _routes {
    return {
      SplashPage.routeName: (_) => const SplashPage(),
      EditLessonPage.routeName: (_) => const EditLessonPage(),
      EditQuestionPage.routeName: (_) => const EditQuestionPage(),
      EditLessonsPage.routeName: (_) => const EditLessonsPage(),
    };
  }
}
