import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:statsy/domain/models/chat_model.dart';
import 'package:uuid/uuid.dart';

class ChatViewmodel extends ChangeNotifier {
  final String modelName = 'gemini-pro';
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  final List<ChatModel> _messages = [];
  bool isLoading = false;

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

  Future<void> ask(String prompt) async {
    if (prompt == "" || apiKey == "") {
      return;
    }
    GenerateContentResponse? response;
    try {
      _setIsLoading(true);
      final history = _history;

      _addMessage(userText: prompt);

      final model = GenerativeModel(model: modelName, apiKey: apiKey);
      final chat = model.startChat(history: history);
      response = await chat.sendMessage(Content.text(prompt));
    } catch (e) {
      onError?.call("Erro, tente novamente.");
      _messages.removeLast();
      notifyListeners();
    } finally {
      if (response != null) {
        _messages[_messages.length - 1] =
            _messages[_messages.length - 1].copyWith(chatText: response.text);
      }
      _setIsLoading(false);
    }
    _setIsLoading(false);
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
    "Responda sempre em pt-BR. Você é um expert em Probabilidade e Estatistica, e deve responder perguntas, dar explicações e auxiliar alunos, de forma resumida e didatica. Responda apenas questões relacionadas com probabilidade e estatistica, e algumas disciplinas relacionadas, como matematica por exemplo, e se for perguntado se alguma outra disciplina, não responda e explique o que você pode fazer.";

const String modelConfigResponse =
    "Ok, vou responder perguntas, dar explicações e auxiliar alunos, de forma resumida e didatica.";
