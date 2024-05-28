import 'package:statsy/domain/models/lesson_model.dart';

class LessonsCache {
  static final LessonsCache _instance = LessonsCache._interno();

  LessonsCache._interno();

  static LessonsCache get instance => _instance;

  List<LessonModel>? _list;

  void set(List<LessonModel> list) {
    _list = [...list];
  }

  List<LessonModel>? get() {
    if (_list == null) return null;
    return [..._list!];
  }
}
