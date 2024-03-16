import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/repository/alternative_repository.dart';

class AlternativeUsecase {
  final AlternativeRepository _repository;

  AlternativeUsecase(this._repository);

  Stream<List<AlternativeModel>> stream(String questionId) {
    return _repository.stream(questionId).map(
          (snapshot) => snapshot.docs
              .map((e) => AlternativeModel.fromMap(e.data(), e.id))
              .toList(),
        );
  }

  Future<List<AlternativeModel>> list(String questionId) async {
    final data = await _repository.list(questionId);
    return data.docs
        .map((doc) => AlternativeModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<String?> save(AlternativeModel alternative) async {
    if (alternative.text == "" || alternative.text.length > 128) {
      return "Alternativa inválida";
    }

    final list = await this.list(alternative.questionId);
    if (list.length >= 5) return "Questões devem ter no máximo 5 alternativas";
    //TODO: validate isCorrect

    await _repository.save(alternative);
    return null;
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
  }
}
