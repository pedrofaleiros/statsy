// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:statsy/domain/models/message_model.dart';

class ChatViewmodel extends ChangeNotifier {
  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages.reversed.toList();

  void _addMessage({required String content, required Role role}) {
    _messages.add(
      MessageModel(
        id: _messages.length.toString(),
        role: role,
        content: content,
      ),
    );
    notifyListeners();
  }

  bool isLoading = false;
  void _setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  Future<void> ask(String prompt) async {
    if (prompt == "" || apiKey == "") {
      return;
    }
    GenerateContentResponse? response;
    try {
      _setIsLoading(true);
      final history = _getHistory();

      _addMessage(role: Role.user, content: prompt);

      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final chat = model.startChat(history: history);
      response = await chat.sendMessage(Content.text(prompt));
    } catch (e) {
      onError?.call("Erro, tente novamente.");
      _messages.removeLast();
      notifyListeners();
    } finally {
      if (response != null) {
        _addMessage(
          role: Role.chat,
          content: response.text ?? "Erro",
        );
      }
      _setIsLoading(false);
    }
    _setIsLoading(false);
  }

  Function(String? message)? onError;

  List<Content> _getHistory() {
    List<Content> list = [];
    if (messages.length % 2 != 0) return [];
    for (int i = 0; i < _messages.length; i++) {
      if (_messages[i].role == Role.user) {
        list.add(Content.text(_messages[i].content));
      } else {
        list.add(Content.model([TextPart(_messages[i].content)]));
      }
    }
    return list;
  }

  // final String modelConfig =
  //     "Responda sempre em pt-BR. Você é um expert em Probabilidade e Estatistica, e deve responder perguntas, dar explicações e auxiliar alunos, de forma resumida e didatica. Responda apenas questões relacionadas com probabilidade e estatistica, e algumas disciplinas relacionadas,como matematica por exemplo.";
}

/* 
MessageModel(
      id: "0",
      role: Role.chat,
      content: "Olá, sou o Chat IA.",
    ),
    MessageModel(
      id: "1",
      role: Role.user,
      content: "Olá chat.",
    ),
    MessageModel(
      id: "2",
      role: Role.user,
      content: "Qual o maior time do brasil?",
    ),
    MessageModel(
      id: "3",
      role: Role.chat,
      content: "O maior time do brasil é o Flamengo.",
    ),
 */
