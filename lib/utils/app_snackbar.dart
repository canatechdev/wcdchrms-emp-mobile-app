import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AppSnackbar {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 4),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showSuccess({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.success,
    );
  }

  static void showError({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.failure,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.warning,
    );
  }

  static void showHelp({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    show(
      context: context,
      title: title,
      message: message,
      contentType: ContentType.help,
    );
  }
}
