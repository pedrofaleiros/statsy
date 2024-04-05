import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statsy/presentation/viewmodel/game_viewmodel.dart';
import 'package:statsy/utils/app_colors.dart';

AppBar questionAppBar(
  BuildContext context,
  Color color,
  Widget? action,
) {
  final vm = context.read<GameViewmodel>();
  return AppBar(
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(
        Icons.close,
        color: AppColors.grey,
      ),
    ),
    title: LinearProgressIndicator(
      color: color,
      value: (vm.total - vm.questions.length) / vm.total,
      borderRadius: BorderRadius.circular(8),
      minHeight: 12,
    ),
    actions: [action ?? Container()],
  );
}
