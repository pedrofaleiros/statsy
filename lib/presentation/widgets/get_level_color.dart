import 'package:flutter/material.dart';
import 'package:statsy/utils/app_colors.dart';

Color getLevelColor(int level) {
  if (level == 1) {
    return AppColors.blue;
  } else if (level == 2) {
    return AppColors.green;
  } else if (level == 3) {
    return AppColors.yellow;
  } else if (level == 4) {
    return AppColors.orange;
  } else {
    return AppColors.red;
  }
}
