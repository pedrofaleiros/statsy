import 'package:flutter/material.dart';
import 'package:statsy/domain/models/chat_model.dart';
import 'package:statsy/presentation/widgets/chat_message.dart';
import 'package:statsy/presentation/widgets/user_message.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
  });

  final ChatModel message;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserMessage(content: message.userText),
        ChatMessage(content: message.chatText),
      ],
    );
  }
}
