class ChatModel {
  final String id;
  final String userText;
  final String? chatText;

  ChatModel({
    required this.id,
    required this.userText,
    this.chatText,
  });

  ChatModel copyWith({
    String? id,
    String? userText,
    String? chatText,
  }) {
    return ChatModel(
      id: id ?? this.id,
      userText: userText ?? this.userText,
      chatText: chatText ?? this.chatText,
    );
  }

  bool get isValid => chatText != null;
}
