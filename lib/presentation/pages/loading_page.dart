import 'package:flutter/material.dart';
import 'package:statsy/utils/app_colors.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.blue),
          const SizedBox(height: 10),
          Text(
            message ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey2,
            ),
          ),
        ],
      ),
    );
  }
}
