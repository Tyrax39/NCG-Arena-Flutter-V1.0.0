import 'package:flutter/material.dart';

void hideOpenDialog({
  required BuildContext context,
}) {
  Navigator.of(context).pop();
}
void showLoadingIndicator(
    {required BuildContext context, required Color color, bool isDark = false}) {
  showDialog(
    barrierDismissible: false,
    useRootNavigator: false,
    context: context,
    builder: (BuildContext context) {
      return Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: color,
            ),
          ],
        ),
      );
    },
  );
}
