import 'package:neoncave_arena/common/flushbar.dart';
import 'package:neoncave_arena/common/snackbar_message.dart';
import 'package:neoncave_arena/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as flutter_widgets;

class SnackbarHelper {
  static SnackbarHelper? _instance;

  SnackbarHelper._internal();

  static SnackbarHelper instance() {
    _instance ??= SnackbarHelper._internal();
    return _instance!;
  }

  Flushbar? _lastFlushbar;
  flutter_widgets.BuildContext? _context;

  void injectContext(BuildContext context) {
    _context = context;
  }

  void showSnackbar(
      {required SnackbarMessage snackbarMessage,
      EdgeInsets margin = const EdgeInsets.all(8)}) async {
    final context = _context;
    if (context == null) return;

    final tempLastFlushbar = _lastFlushbar;
    if (tempLastFlushbar != null && tempLastFlushbar.isShowing()) {
      await tempLastFlushbar.dismiss();
    }

    _lastFlushbar = Flushbar(
        animationDuration: const Duration(milliseconds: 850),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        duration: snackbarMessage.duration,
        messageText: Text(snackbarMessage.content,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColor.white, fontSize: 15)),
        margin: margin,
        shouldIconPulse: false,
        mainButton: null,
        leftBarIndicatorColor: AppColor.black,
        onStatusChanged: (status) {},
        backgroundColor: snackbarMessage.isForError
            ? AppColor.red.withOpacity(0.9)
            : AppColor.primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)));
    // ignore: use_build_context_synchronously
    _lastFlushbar?.show(context);
  }

  void showSuccessSnackbar(String message,
      {EdgeInsets margin = const EdgeInsets.all(8)}) async {
    final context = _context;
    if (context == null) return;

    final theme = Theme.of(context);

    final tempLastFlushbar = _lastFlushbar;
    if (tempLastFlushbar != null && tempLastFlushbar.isShowing()) {
      await tempLastFlushbar.dismiss();
    }

    _lastFlushbar = Flushbar(
      animationDuration: const Duration(milliseconds: 850),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      duration: const Duration(seconds: 2),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontSize: 15,
        ),
      ),
      margin: margin,
      shouldIconPulse: false,
      mainButton: null,
      leftBarIndicatorColor: theme.colorScheme.primary,
      onStatusChanged: (status) {},
      backgroundColor: theme.colorScheme.primaryContainer,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
    _lastFlushbar?.show(context);
  }

  void showErrorSnackbar(String message,
      {EdgeInsets margin = const EdgeInsets.all(8)}) async {
    final context = _context;
    if (context == null) return;

    final theme = Theme.of(context);

    final tempLastFlushbar = _lastFlushbar;
    if (tempLastFlushbar != null && tempLastFlushbar.isShowing()) {
      await tempLastFlushbar.dismiss();
    }

    _lastFlushbar = Flushbar(
      animationDuration: const Duration(milliseconds: 850),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      duration: const Duration(seconds: 2),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.error,
          fontSize: 15,
        ),
      ),
      margin: margin,
      shouldIconPulse: false,
      mainButton: null,
      leftBarIndicatorColor: theme.colorScheme.error,
      onStatusChanged: (status) {},
      backgroundColor: theme.colorScheme.primaryContainer,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    );
    _lastFlushbar?.show(context);
  }
}
