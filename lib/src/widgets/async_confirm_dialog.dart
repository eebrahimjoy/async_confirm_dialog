import 'package:flutter/material.dart';

import '../models/async_confirm_dialog_style.dart';
import '../models/confirm_dialog_variant.dart';
import '../models/dialog_platform.dart';
import 'internal/cupertino_confirm_dialog_view.dart';
import 'internal/material_confirm_dialog_view.dart';

/// A fully self-contained, async-aware confirmation dialog.
///
/// Most applications should not instantiate this widget directly. Prefer the
/// ergonomic [AppDialog.confirm] helper or the `BuildContext.confirm`
/// extension, which wrap this widget in a `showDialog` call and return a
/// `Future<bool?>`.
///
/// Instantiating the widget directly is useful when you need full control over
/// the route, for example to supply a custom transition or to embed the dialog
/// inside an existing `showGeneralDialog` call.
///
/// ## Async lifecycle
///
/// When [onConfirm] is provided and the user taps the confirm button, the
/// dialog enters a loading state:
///
/// * the confirm action is replaced by a progress indicator,
/// * the cancel action is disabled,
/// * back navigation and barrier dismissal are suppressed,
/// * repeated taps are ignored.
///
/// If [onConfirm] completes successfully the dialog is popped with `true`
/// (unless [dismissOnConfirm] is `false`). If it throws, the loading state is
/// cleared, [onError] is invoked, and an inline error message is shown so the
/// user can retry.
class AsyncConfirmDialog extends StatefulWidget {
  /// Creates an async-aware confirmation dialog.
  const AsyncConfirmDialog({
    super.key,
    this.title,
    this.message,
    this.content,
    this.icon,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.onError,
    this.variant = ConfirmDialogVariant.normal,
    this.platform = DialogPlatform.adaptive,
    this.showCancelButton = true,
    this.dismissOnConfirm = true,
    this.dismissOnError = false,
    this.errorMessage,
    this.loadingText,
    this.style,
    this.insetPadding,
  });

  /// Optional title displayed at the top of the dialog.
  final String? title;

  /// Optional descriptive message displayed in the body.
  final String? message;

  /// Optional custom widget displayed in the body, below [message].
  ///
  /// Use this to render rich content such as text fields or lists.
  final Widget? content;

  /// Optional icon displayed above the title.
  final Widget? icon;

  /// Label of the confirm action. Defaults to `'Confirm'`.
  final String confirmText;

  /// Label of the cancel action. Defaults to `'Cancel'`.
  final String cancelText;

  /// Optional asynchronous callback executed when the user confirms.
  ///
  /// While the returned future is pending the dialog renders a loading state
  /// and blocks all other interaction. Throwing from this callback is handled
  /// gracefully; see the class documentation for details.
  final Future<void> Function()? onConfirm;

  /// Optional callback invoked when the user cancels the dialog.
  final VoidCallback? onCancel;

  /// Optional callback invoked when [onConfirm] throws.
  ///
  /// The dialog remains open (unless [dismissOnError] is `true`) and shows an
  /// inline error so the user can retry.
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// Semantic intent of the primary action. Defaults to
  /// [ConfirmDialogVariant.normal].
  final ConfirmDialogVariant variant;

  /// Design language used to render the dialog. Defaults to
  /// [DialogPlatform.adaptive].
  final DialogPlatform platform;

  /// Whether to render the cancel action. Defaults to `true`.
  final bool showCancelButton;

  /// Whether to automatically pop the dialog with `true` after [onConfirm]
  /// completes successfully. Defaults to `true`.
  final bool dismissOnConfirm;

  /// Whether to pop the dialog with `false` when [onConfirm] throws.
  ///
  /// Defaults to `false`, which keeps the dialog open and displays the error
  /// inline so the user can retry.
  final bool dismissOnError;

  /// Custom error text shown when [onConfirm] throws and [dismissOnError] is
  /// `false`. When omitted, the thrown error's `toString()` is used.
  final String? errorMessage;

  /// Optional label rendered next to the progress indicator while loading.
  final String? loadingText;

  /// Optional visual overrides for the dialog.
  final AsyncConfirmDialogStyle? style;

  /// Padding around the dialog. Passed through to the Material `AlertDialog`.
  final EdgeInsetsGeometry? insetPadding;

  @override
  State<AsyncConfirmDialog> createState() => _AsyncConfirmDialogState();
}

class _AsyncConfirmDialogState extends State<AsyncConfirmDialog> {
  bool _isLoading = false;
  String? _errorText;

  bool get _isDestructive => widget.variant.isDestructive;

  Future<void> _handleConfirm() async {
    if (_isLoading) {
      return;
    }

    final onConfirm = widget.onConfirm;
    if (onConfirm == null) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      await onConfirm();
      if (!mounted) {
        return;
      }
      if (widget.dismissOnConfirm) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }
      try {
        widget.onError?.call(error, stackTrace);
      } on Object {
        // A failing error handler must not mask the dialog's own error state.
      }
      if (widget.dismissOnError) {
        Navigator.of(context).pop(false);
        return;
      }
      setState(() {
        _isLoading = false;
        _errorText = widget.errorMessage ?? _formatError(error);
      });
    }
  }

  void _handleCancel() {
    if (_isLoading) {
      return;
    }
    widget.onCancel?.call();
    Navigator.of(context).pop(false);
  }

  /// Turns a thrown [error] into a readable inline message.
  ///
  /// Exception-prefix noise such as `Exception: ` or `Bad state: ` is
  /// stripped so the visible text is the actual human-readable message.
  String _formatError(Object error) {
    final text = error.toString().trim();
    if (text.isEmpty) {
      return 'An unexpected error occurred. Please try again.';
    }
    final separator = text.indexOf(': ');
    if (separator > 0) {
      final message = text.substring(separator + 2).trim();
      if (message.isNotEmpty) {
        return message;
      }
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedPlatform = widget.platform.resolve(context);

    final Widget view;
    if (resolvedPlatform == DialogPlatform.cupertino) {
      view = CupertinoConfirmDialogView(
        dialog: widget,
        isDestructive: _isDestructive,
        isLoading: _isLoading,
        errorText: _errorText,
        onConfirmPressed: _handleConfirm,
        onCancelPressed: _handleCancel,
      );
    } else {
      view = MaterialConfirmDialogView(
        dialog: widget,
        isDestructive: _isDestructive,
        isLoading: _isLoading,
        errorText: _errorText,
        onConfirmPressed: _handleConfirm,
        onCancelPressed: _handleCancel,
      );
    }

    return PopScope(canPop: !_isLoading, child: view);
  }
}
