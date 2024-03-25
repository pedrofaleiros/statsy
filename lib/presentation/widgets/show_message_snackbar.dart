import 'package:flutter/material.dart';

void showMessageSnackBar({
  required BuildContext context,
  required String message,
  Icon? icon,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      dismissDirection: DismissDirection.horizontal,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (icon != null) icon,
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              softWrap: true,
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
