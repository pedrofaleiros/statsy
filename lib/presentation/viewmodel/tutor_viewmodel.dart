import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:statsy/domain/models/chat_model.dart';
import 'package:statsy/domain/models/question_model.dart';
import 'package:statsy/domain/usecase/chat_usecase.dart';
import 'package:statsy/utils/service_locator.dart';
import 'package:uuid/uuid.dart';

class TutorViewmodel extends ChangeNotifier {
  final _usecase = locator<ChatUsecase>();

  final List<ChatModel> _messages = [];
  bool isLoading = false;
  bool isTipping = false;

  void clear({QuestionModel? questionModel}) {
    _messages.clear();
    isLoading = false;
    isTipping = false;
  }

  List<ChatModel> get messages => _messages.reversed.toList();

  void _addMessage({required String userText, String? chatText}) {
    _messages.add(
      ChatModel(id: const Uuid().v4(), userText: userText, chatText: chatText),
    );
    notifyListeners();
  }

  void _setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void _setIsTipping(bool value) {
    isTipping = value;
    notifyListeners();
  }

  Future<void> ask(String prompt) async {
    if (prompt == "") {
      return;
    }
    try {
      _setIsLoading(true);
      final history = _history;

      _addMessage(userText: prompt);

      final response = _usecase.ask(prompt, history);

      _setIsLoading(false);
      _setIsTipping(true);
      await for (final chunk in response) {
        if (chunk.text != null) {
          _messages.last = _messages.last.copyWith(
              chatText: (_messages.last.chatText ?? "") + chunk.text!);
          notifyListeners();
        }
      }
      _setIsTipping(false);
    } catch (e) {
      onError?.call("Erro, tente novamente.");
      _messages.removeLast();
      notifyListeners();
    } finally {
      _setIsLoading(false);
    }
  }

  List<Content> get _history {
    List<Content> list = [];
    list.add(Content.text(modelConfig));
    list.add(Content.model([TextPart(modelConfigResponse)]));
    for (var mes in _messages) {
      if (mes.isValid) {
        list.add(Content.text(mes.userText));
        list.add(Content.model([TextPart(mes.chatText!)]));
      }
    }
    return list;
  }

  Function(String? message)? onError;
}

const String modelConfig =
    "Responda sempre em pt-BR. Você é um expert em Probabilidade e Estatistica, e deve responder perguntas, dar explicações e auxiliar alunos em questões, de forma resumida e didatica. Responda apenas questões relacionadas com probabilidade e estatistica, e algumas disciplinas relacionadas, como matematica por exemplo, e se for perguntado se alguma outra disciplina, não responda e explique o que você pode fazer.";

const String modelConfigResponse =
    "Ok, vou responder perguntas, dar explicações e auxiliar alunos, de forma resumida e didatica.";
