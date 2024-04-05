import 'package:statsy/domain/models/alternative_model.dart';

class AlternativesCache {
  static final AlternativesCache _instance = AlternativesCache._interno();

  AlternativesCache._interno();

  static AlternativesCache get instance => _instance;

  final Map<String, List<AlternativeModel>> _map = {};

  void set(String questionId, List<AlternativeModel> list) {
    _map[questionId] = [...list];
  }

  List<AlternativeModel>? get(String questionId) {
    final list = _map[questionId];
    if (list == null) return null;
    return [...list];
  }
}
