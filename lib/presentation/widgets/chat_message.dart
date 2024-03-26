import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MarkdownBody(
              data: content,
              selectable: true,
            ),
          ),
        ),
      ),
    );
  }
}
