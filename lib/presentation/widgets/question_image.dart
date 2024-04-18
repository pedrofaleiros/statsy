import 'package:flutter/material.dart';

class QuestionImage extends StatelessWidget {
  const QuestionImage({super.key, required this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    if (image == null) return Container();
    return Image.network(image!);
  }
}