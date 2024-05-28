import 'package:statsy/domain/cache/lessons_cache.dart';
import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/repository/lesson_repository.dart';
import 'package:statsy/domain/usecase/question_usecase.dart';
import 'package:statsy/utils/service_locator.dart';

class LessonUsecase {
  final LessonRepository _repository;

  LessonUsecase(this._repository);

  Stream<List<LessonModel>> streamLessons() {
    return _repository.streamLessons().map(
          (snapshot) => snapshot.docs
              .map((e) => LessonModel.fromMap(e.data(), e.id))
              .toList(),
        );
  }

  Future<List<LessonModel>> listLessons() async {
    final cache = LessonsCache.instance.get();
    if (cache != null) return cache;

    final data = await _repository.listLessons();
    final list = data.docs
        .map((doc) => LessonModel.fromMap(doc.data(), doc.id))
        .toList();

    LessonsCache.instance.set(list);
    return list;
  }

  Stream<List<LessonModel>> streamLessonsByLevel(int level) {
    return _repository.streamLessonsByLevel(level).map(
          (snapshot) => snapshot.docs
              .map((e) => LessonModel.fromMap(e.data(), e.id))
              .toList(),
        );
  }

  Future<List<LessonModel>> listLessonsByLevel(int level) async {
    final data = await _repository.listLessonsByLevel(level);
    return data.docs
        .map((doc) => LessonModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<String?> saveLesson(LessonModel lesson) async {
    if (lesson.name == "" || lesson.name.length > 64) return "Nome inválido";
    if (lesson.points <= 0 || lesson.points > 1000) return "Pontos inválidos";
    if (lesson.level <= 0 || lesson.level > 10) return "Nível inválido";
    if (lesson.description == "" || lesson.description.length > 64) {
      return "Descrição inválida";
    }
    await _repository.save(lesson);
    return null;
  }

  Future<void> delete(String id) async {
    final questionUsecase = locator<QuestionUsecase>();
    final questions = await questionUsecase.list(id);
    for (var q in questions) {
      await questionUsecase.delete(q.id);
    }
    await _repository.delete(id);
  }
}
