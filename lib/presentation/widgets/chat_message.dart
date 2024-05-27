import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:statsy/utils/app_colors.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.content});

  final String? content;

  @override
  Widget build(BuildContext context) {
    return content == null
        ? _loading
        : PopupMenuButton<int>(
            position: PopupMenuPosition.under,
            offset: const Offset(0, -64),
            elevation: 32,
            tooltip: "",
            onSelected: content == null
                ? null
                : (value) async {
                    await Clipboard.setData(
                      ClipboardData(text: content ?? ""),
                    );
                  },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Copiar"),
                      Icon(Icons.copy),
                    ],
                  ),
                ),
              ];
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MarkdownBody(data: content!),
              ),
            ),
          );
  }

  Widget get _loading {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.orange,
        ),
      ),
    );
  }
}
