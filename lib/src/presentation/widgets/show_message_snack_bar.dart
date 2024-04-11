import 'package:flutter/material.dart';

Future<void> showMessageSnackBar({
  required BuildContext context,
  required String message,
}) async {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      dismissDirection: DismissDirection.horizontal,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
