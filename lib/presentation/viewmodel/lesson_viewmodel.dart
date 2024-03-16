import 'package:statsy/domain/models/lesson_model.dart';
import 'package:statsy/domain/usecase/lesson_usecase.dart';
import 'package:statsy/utils/service_locator.dart';

class LessonViewmodel {
  final _usecase = locator<LessonUsecase>();

  Stream<List<LessonModel>> get lessons => _usecase.streamLessons();

  Future<List<LessonModel>> listLessons() async {
    return await _usecase.listLessons();
  }

  Future<void> saveLesson(LessonModel lesson) async {
    final res = await _usecase.saveLesson(lesson);
    if (res == null) {
      onSuccess?.call();
    } else {
      onError?.call(res);
    }
  }

  Future<void> delete(String id) async {
    await _usecase.delete(id);
    onSuccess?.call();
  }

  Function()? onSuccess;
  Function(String message)? onError;
}
