import 'package:flutter/material.dart';

import '../../models/async_confirm_dialog_style.dart';
import '../../models/dialog_platform.dart';
import '../async_confirm_dialog.dart';
import 'async_action_content.dart';
import 'confirm_dialog_body.dart';

/// Material-specific rendering of an [AsyncConfirmDialog].
///
/// The view is stateless: all interactive state lives in the dialog's
/// [State]. This widget is package-internal.
class MaterialConfirmDialogView extends StatelessWidget {
  /// Creates a Material rendering of a confirmation dialog.
  const MaterialConfirmDialogView({
    super.key,
    required this.dialog,
    required this.isDestructive,
    required this.isLoading,
    required this.errorText,
    required this.onConfirmPressed,
    required this.onCancelPressed,
  });

  /// The owning dialog widget.
  final AsyncConfirmDialog dialog;

  /// Whether the confirm action is destructive.
  final bool isDestructive;

  /// Whether the confirm action is currently loading.
  final bool isLoading;

  /// Inline error text, if any.
  final String? errorText;

  /// Invoked when the confirm action is pressed.
  final VoidCallback onConfirmPressed;

  /// Invoked when the cancel action is pressed.
  final VoidCallback onCancelPressed;

  /// Background colour for the confirm action.
  Color _resolveConfirmBackground(BuildContext context, AsyncConfirmDialogStyle s) {
    if (isDestructive) {
      return s.destructiveColor ?? Theme.of(context).colorScheme.error;
    }
    return s.confirmColor ?? Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final s = dialog.style ?? const AsyncConfirmDialogStyle();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final titleStyle = (s.titleTextStyle ?? theme.textTheme.titleMedium)
        ?.copyWith(color: s.titleColor ?? scheme.onSurface);
    final messageColor = s.messageColor ?? scheme.onSurfaceVariant;
    final confirmColor = _resolveConfirmBackground(context, s);
    final onConfirmColor = _textColorOn(confirmColor);

    final titleAlign = s.titleAlign ?? TextAlign.start;
    final contentAlign = s.contentAlign ?? TextAlign.start;

    return AlertDialog(
      backgroundColor: s.backgroundColor,
      elevation: s.elevation,
      shape: s.borderRadius != null
          ? RoundedRectangleBorder(borderRadius: s.borderRadius!)
          : null,
      insetPadding: _resolveInsetPadding(dialog.insetPadding),
      icon: dialog.icon,
      title: dialog.title == null
          ? null
          : Text(dialog.title!, textAlign: titleAlign, style: titleStyle),
      contentPadding: s.contentPadding,
      content: ConfirmDialogBody(
        message: dialog.message,
        content: dialog.content,
        errorText: errorText,
        textAlign: contentAlign,
        messageColor: messageColor,
        messageTextStyle: s.messageTextStyle,
        errorTextStyle: s.errorTextStyle,
      ),
      actionsPadding: s.actionsPadding,
      actionsOverflowAlignment: OverflowBarAlignment.end,
      actions: [
        if (dialog.showCancelButton)
          TextButton(
            onPressed: isLoading ? null : onCancelPressed,
            style: TextButton.styleFrom(
              foregroundColor: s.cancelColor ?? scheme.primary,
              textStyle: s.actionTextStyle,
            ),
            child: AsyncActionContent(
              label: dialog.cancelText,
              platform: DialogPlatform.material,
              isLoading: false,
              textStyle: s.actionTextStyle,
            ),
          ),
        FilledButton(
          onPressed: isLoading ? null : onConfirmPressed,
          style: FilledButton.styleFrom(
            backgroundColor: confirmColor,
            foregroundColor: onConfirmColor,
            disabledBackgroundColor: confirmColor,
            disabledForegroundColor: onConfirmColor,
            textStyle: s.actionTextStyle,
          ),
          child: AsyncActionContent(
            label: dialog.confirmText,
            loadingLabel: dialog.loadingText,
            platform: DialogPlatform.material,
            isLoading: isLoading,
            progressColor: onConfirmColor,
            textStyle: s.actionTextStyle,
          ),
        ),
      ],
    );
  }

  static Color _textColorOn(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5
        ? Colors.black.withValues(alpha: 0.87)
        : Colors.white;
  }

  static EdgeInsets? _resolveInsetPadding(EdgeInsetsGeometry? value) {
    return value?.resolve(TextDirection.ltr);
  }
}