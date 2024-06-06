import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatUsecase {
  // final String modelName = 'gemini-pro';
  final String modelName = 'gemini-1.5-flash';
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  Stream<GenerateContentResponse> ask(String prompt, List<Content> history) {
    final model = GenerativeModel(model: modelName, apiKey: apiKey);
    final chat = model.startChat(history: history);
    return chat.sendMessageStream(Content.text(prompt));
  }

  Stream<GenerateContentResponse> askNoHistory(String prompt) {
    final model = GenerativeModel(model: modelName, apiKey: apiKey);
    return model.generateContentStream([Content.text(prompt)]);
  }
}
