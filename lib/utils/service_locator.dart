import 'package:get_it/get_it.dart';
import 'package:statsy/domain/repository/alternative_repository.dart';
import 'package:statsy/domain/repository/answer_repository.dart';
import 'package:statsy/domain/repository/implementation/alternative_repository_impl.dart';
import 'package:statsy/domain/repository/implementation/answer_repository_impl.dart';
import 'package:statsy/domain/repository/implementation/lesson_repository_impl.dart';
import 'package:statsy/domain/repository/implementation/question_repository_impl.dart';
import 'package:statsy/domain/repository/lesson_repository.dart';
import 'package:statsy/domain/repository/question_repository.dart';
import 'package:statsy/domain/usecase/alternative_usecase.dart';
import 'package:statsy/domain/usecase/answer_usecase.dart';
import 'package:statsy/domain/usecase/auth_usecase.dart';
import 'package:statsy/domain/usecase/chat_usecase.dart';
import 'package:statsy/domain/usecase/lesson_usecase.dart';
import 'package:statsy/domain/usecase/question_usecase.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // ---------- LESSON ----------
  locator.registerLazySingleton<LessonRepository>(
    () => LessonRepositoryImpl(),
  );
  locator.registerFactory(
    () => LessonUsecase(locator<LessonRepository>()),
  );

  // ---------- QUESTION ----------
  locator.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(),
  );
  locator.registerFactory(
    () => QuestionUsecase(locator<QuestionRepository>()),
  );

  // ---------- ALTERNATIVE ----------
  locator.registerLazySingleton<AlternativeRepository>(
    () => AlternativeRepositoryImpl(),
  );
  locator.registerFactory(
    () => AlternativeUsecase(locator<AlternativeRepository>()),
  );

  // ---------- ANSWER ----------
  locator.registerLazySingleton<AnswerRepository>(
    () => AnswerRepositoryImpl(),
  );
  locator.registerFactory(
    () => AnswerUsecase(locator<AnswerRepository>()),
  );

  // ---------- GOOGLE ----------
  locator.registerFactory(() => AuthUsecase());

  locator.registerFactory(() => ChatUsecase());
}
