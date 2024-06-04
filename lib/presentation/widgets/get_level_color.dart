import 'package:flutter/material.dart';
import 'package:statsy/utils/app_colors.dart';

Color getLevelColor(int level) {
  if (level == 1) {
    return AppColors.mint;
  } else if (level == 2) {
    return AppColors.cyan;
  } else if (level == 3) {
    return AppColors.blue;
  } else if (level == 4) {
    return AppColors.indigo;
  } else if (level == 5) {
    return AppColors.purple;
  } else {
    return AppColors.purple;
  }
}
