import 'package:flutter/cupertino.dart';
import 'package:statsy/domain/models/alternative_model.dart';
import 'package:statsy/domain/usecase/alternative_usecase.dart';
import 'package:statsy/domain/usecase/answer_usecase.dart';
import 'package:statsy/utils/service_locator.dart';

class AnswerViewmodel extends ChangeNotifier {
  final _altUsecase = locator<AlternativeUsecase>();

  final _usecase = locator<AnswerUsecase>();
  //TODO:

  String selectedAltId = "";

  List<AlternativeModel> alternatives = [];

  void init() {
    selectedAltId = "";
    alternatives.clear();
  }

  Future<void> loadAlternatives(String questionId) async {
    alternatives = await _altUsecase.list(questionId);
    notifyListeners();
  }

  Future<void> answer() async {}
}
