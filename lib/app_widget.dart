import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/pages/admin/edit_lesson_page.dart';
import 'package:statsy/presentation/pages/admin/edit_question_page.dart';
import 'package:statsy/presentation/pages/admin/edit_lessons_page.dart';
import 'package:statsy/presentation/pages/answer/load_lesson_page.dart';
import 'package:statsy/presentation/pages/answer/load_question_page.dart';
import 'package:statsy/presentation/pages/progress_page.dart';
import 'package:statsy/presentation/pages/splash_page.dart';
import 'package:statsy/presentation/viewmodel/alternative_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/answer_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/auth_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/chat_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/game_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/lesson_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/question_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/tutor_viewmodel.dart';
import 'package:statsy/presentation/viewmodel/user_data_viewmodel.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatViewmodel>(
          create: (context) => ChatViewmodel(),
        ),
        ChangeNotifierProvider<TutorViewmodel>(
          create: (context) => TutorViewmodel(),
        ),
        ChangeNotifierProvider<AuthViewmodel>(
          create: (context) => AuthViewmodel(),
        ),
        ChangeNotifierProvider<GameViewmodel>(
          create: (context) => GameViewmodel(),
        ),
        Provider<AnswerViewmodel>(
          create: (context) => AnswerViewmodel(),
        ),
        Provider<LessonViewmodel>(
          create: (context) => LessonViewmodel(),
        ),
        Provider<QuestionViewmodel>(
          create: (context) => QuestionViewmodel(),
        ),
        Provider<AlternativeViewmodel>(
          create: (context) => AlternativeViewmodel(),
        ),
        Provider<UserDataViewmodel>(
          create: (context) => UserDataViewmodel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "OpenSans"),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: Typography().white.apply(fontFamily: "OpenSans"),
        ),
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
      LoadLessonPage.routeName: (_) => const LoadLessonPage(),
      LoadQuestionPage.routeName: (_) => const LoadQuestionPage(),
      ProgressPage.routeName: (_) => const ProgressPage(),
    };
  }
}
