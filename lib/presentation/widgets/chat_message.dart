import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:statsy/presentation/widgets/aura_widget.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.content});

  final String? content;

  @override
  Widget build(BuildContext context) {
    return content == null
        ? _loading
        : Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MarkdownBody(
                data: content!,
                selectable: true,
              ),
            ),
          );
  }

  Widget get _loading {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: const Center(
        child: AuraWidget(size: 96),
      ),
    );
  }
}
