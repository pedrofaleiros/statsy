import 'package:statsy/domain/cache/alternatives_cache.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/repository/alternative_repository.dart';

class AlternativeUsecase {
  final AlternativeRepository _repository;

  AlternativeUsecase(this._repository);

  Future<List<AlternativeModel>> list(String questionId) async {
    final cache = AlternativesCache.instance.get(questionId);
    if (cache != null) return cache;

    final data = await _repository.list(questionId);

    final list = data.docs
        .map((doc) => AlternativeModel.fromMap(doc.data(), doc.id))
        .toList();

    AlternativesCache.instance.set(questionId, list);
    return list;
  }

  Future<String?> save(AlternativeModel alternative) async {
    alternative = replace(alternative);

    if (alternative.text == "" || alternative.text.length > 256) {
      return "Texto inválido";
    }

    await _repository.save(alternative);
    return null;
  }

  AlternativeModel replace(AlternativeModel alternative) {
    alternative = alternative.copyWith(
      text: alternative.text.replaceAll('\n', ''),
    );
    alternative = alternative.copyWith(
      text: alternative.text.replaceAll('\r', ''),
    );
    alternative = alternative.copyWith(
      text: alternative.text.replaceAll('  ', ''),
    );
    return alternative;
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
  }

  Future<AlternativeModel?> detail(String id) async {
    final data = await _repository.detail(id);
    if (data.data() != null) {
      return AlternativeModel.fromMap(data.data()!, data.id);
    }
    return null;
  }

  Stream<List<AlternativeModel>> stream(String questionId) {
    return _repository.stream(questionId).map(
          (snapshot) => snapshot.docs
              .map((e) => AlternativeModel.fromMap(e.data(), e.id))
              .toList(),
        );
  }
}
