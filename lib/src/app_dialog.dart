import 'package:flutter/material.dart';

import 'models/async_confirm_dialog_style.dart';
import 'models/confirm_dialog_variant.dart';
import 'models/dialog_platform.dart';
import 'widgets/async_confirm_dialog.dart';

/// A zero-boilerplate entry point for showing async-aware confirmation dialogs.
///
/// This is the primary, recommended API. It wraps [AsyncConfirmDialog] in a
/// `showDialog` call and returns a `Future<bool?>`:
///
/// * `true` when the user confirms,
/// * `false` when the user cancels (or if [onConfirm] fails and
///   [AsyncConfirmDialog.dismissOnError] is `true`),
/// * `null` when the dialog is dismissed (for example by barrier tap), unless
///   suppressed via `barrierDismissible`.
///
/// ```dart
/// final confirmed = await AppDialog.confirm(
///   context,
///   title: 'Delete note?',
///   message: 'This cannot be undone.',
///   variant: ConfirmDialogVariant.destructive,
///   onConfirm: () async { await notesRepository.remove(id); },
/// );
/// if (confirmed == true) {
///   // Perform any follow-up work...
/// }
/// ```
abstract final class AppDialog {
  AppDialog._();

  /// Shows a confirmation dialog and returns a `Future<bool?>` describing the
  /// user's decision (see the class documentation for the exact semantics).
  ///
  /// All named parameters map directly onto [AsyncConfirmDialog] and its
  /// [AsyncConfirmDialogStyle].
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    Widget? icon,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Future<void> Function()? onConfirm,
    VoidCallback? onCancel,
    void Function(Object error, StackTrace stackTrace)? onError,
    ConfirmDialogVariant variant = ConfirmDialogVariant.normal,
    DialogPlatform platform = DialogPlatform.adaptive,
    bool showCancelButton = true,
    bool dismissOnConfirm = true,
    bool dismissOnError = false,
    String? errorMessage,
    String? loadingText,
    AsyncConfirmDialogStyle? style,
    EdgeInsetsGeometry? insetPadding,
    bool barrierDismissible = false,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (dialogContext) {
        return AsyncConfirmDialog(
          title: title,
          message: message,
          content: content,
          icon: icon,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirm: onConfirm,
          onCancel: onCancel,
          onError: onError,
          variant: variant,
          platform: platform,
          showCancelButton: showCancelButton,
          dismissOnConfirm: dismissOnConfirm,
          dismissOnError: dismissOnError,
          errorMessage: errorMessage,
          loadingText: loadingText,
          style: style,
          insetPadding: insetPadding,
        );
      },
    ).then((value) => value);
  }
}

/// Convenience extension on [BuildContext] that reads like a sentence.
///
/// ```dart
/// final ok = await context.confirm(
///   title: 'Log out?',
///   message: 'You will need to sign in again.',
///   variant: ConfirmDialogVariant.destructive,
///   onConfirm: () => auth.signOut(),
/// );
/// ```
extension ConfirmDialogContextX on BuildContext {
  /// Shows [AppDialog.confirm] as if speaking to the current [BuildContext].
  ///
  /// All parameters map directly onto [AppDialog.confirm]; see that method for
  /// full documentation.
  Future<bool?> confirm({
    required String title,
    String? message,
    Widget? content,
    Widget? icon,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Future<void> Function()? onConfirm,
    VoidCallback? onCancel,
    void Function(Object error, StackTrace stackTrace)? onError,
    ConfirmDialogVariant variant = ConfirmDialogVariant.normal,
    DialogPlatform platform = DialogPlatform.adaptive,
    bool showCancelButton = true,
    bool dismissOnConfirm = true,
    bool dismissOnError = false,
    String? errorMessage,
    String? loadingText,
    AsyncConfirmDialogStyle? style,
    EdgeInsetsGeometry? insetPadding,
    bool barrierDismissible = false,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return AppDialog.confirm(
      this,
      title: title,
      message: message,
      content: content,
      icon: icon,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      onError: onError,
      variant: variant,
      platform: platform,
      showCancelButton: showCancelButton,
      dismissOnConfirm: dismissOnConfirm,
      dismissOnError: dismissOnError,
      errorMessage: errorMessage,
      loadingText: loadingText,
      style: style,
      insetPadding: insetPadding,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }
}