import 'dart:async';

import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/usecase/alternative_usecase.dart';
import 'package:statsy/utils/service_locator.dart';

class AlternativeViewmodel {
  final _usecase = locator<AlternativeUsecase>();

  Stream<List<AlternativeModel>> stream(String questionId) {
    return _usecase.stream(questionId);
  }

  Future<List<AlternativeModel>> list(String questionId) async {
    return await _usecase.list(questionId);
  }

  Future<void> save(AlternativeModel alternative) async {
    final res = await _usecase.save(alternative);
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
