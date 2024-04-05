import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:statsy/utils/app_colors.dart';

Future<void> showWrongAnswer(
  BuildContext context,
  String message,
  String correct,
) async {
  await showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: ListTile(
              leading: const Icon(
                Icons.close,
                color: AppColors.red,
              ),
              title: Text(
                message,
                style: const TextStyle(
                  color: AppColors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Alternativa correta: $correct",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: CupertinoButton(
              color: AppColors.red,
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Próximo",
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
