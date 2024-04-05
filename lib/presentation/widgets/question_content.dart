import 'package:flutter/material.dart';

class QuestionContent extends StatelessWidget {
  const QuestionContent({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
