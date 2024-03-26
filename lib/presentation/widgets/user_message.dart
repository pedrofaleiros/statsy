import 'package:flutter/material.dart';
import 'package:statsy/utils/app_colors.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: Align(
        alignment: Alignment.centerRight,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          color: AppColors.green,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              content,
              style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
