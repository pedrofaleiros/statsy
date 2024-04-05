import 'package:flutter/material.dart';
import 'package:statsy/utils/app_colors.dart';

Color getLevelColor(int level) {
  if (level == 1) {
    return AppColors.blue;
  } else if (level == 2) {
    return AppColors.orange;
  } else if (level == 3) {
    return AppColors.purple;
  } else if (level == 4) {
    return AppColors.yellow;
  } else {
    return AppColors.red;
  }
}
