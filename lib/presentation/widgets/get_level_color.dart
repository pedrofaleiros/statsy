import 'package:flutter/material.dart';
import 'package:statsy/utils/app_colors.dart';

Color getLevelColor(int level) {
  if (level == 1) {
    return AppColors.green;
  } else if (level == 2) {
    return AppColors.blue;
  } else if (level == 3) {
    return AppColors.yellow;
  } else if (level == 4) {
    return AppColors.orange;
  } else if (level == 5) {
    return AppColors.red;
  } else if (level == 6) {
    return AppColors.pink;
  } else if (level == 7) {
    return AppColors.purple;
  } else {
    return AppColors.red;
  }
}
