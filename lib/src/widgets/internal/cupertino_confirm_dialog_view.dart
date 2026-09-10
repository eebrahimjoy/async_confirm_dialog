import 'package:flutter/cupertino.dart';

import '../../models/async_confirm_dialog_style.dart';
import '../../models/dialog_platform.dart';
import '../async_confirm_dialog.dart';
import 'async_action_content.dart';
import 'confirm_dialog_body.dart';

/// Cupertino-specific rendering of an [AsyncConfirmDialog].
///
/// The view is stateless: all interactive state lives in the dialog's
/// [State]. This widget is package-internal.
class CupertinoConfirmDialogView extends StatelessWidget {
  /// Creates a Cupertino rendering of a confirmation dialog.
  const CupertinoConfirmDialogView({
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

  @override
  Widget build(BuildContext context) {
    final s = dialog.style ?? const AsyncConfirmDialogStyle();
    final cupertinoTheme = CupertinoTheme.of(context);

    final titleStyle = (s.titleTextStyle ??
            cupertinoTheme.textTheme.textStyle.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.black,
            ))
        .copyWith(color: s.titleColor);

    final titleAlign = s.titleAlign ?? TextAlign.center;
    final contentAlign = s.contentAlign ?? TextAlign.center;

    final messageColor = s.messageColor ?? CupertinoColors.systemGrey;

    return CupertinoAlertDialog(
      actions: _isErrorVisible(context)
          ? [
              CupertinoDialogAction(
                isDefaultAction: false,
                onPressed: onCancelPressed,
                child: Text(dialog.cancelText, style: s.actionTextStyle),
              ),
            ]
          : [
              if (dialog.showCancelButton)
                CupertinoDialogAction(
                  isDefaultAction: false,
                  onPressed: isLoading ? null : onCancelPressed,
                  child: Text(dialog.cancelText, style: s.actionTextStyle),
                ),
              CupertinoDialogAction(
                isDestructiveAction: isDestructive,
                isDefaultAction: !isDestructive,
                onPressed: isLoading ? null : onConfirmPressed,
                child: AsyncActionContent(
                  label: dialog.confirmText,
                  loadingLabel: dialog.loadingText,
                  platform: DialogPlatform.cupertino,
                  isLoading: isLoading,
                  progressColor: isDestructive
                      ? CupertinoColors.systemRed
                      : cupertinoTheme.primaryColor,
                  textStyle: s.actionTextStyle ??
                      TextStyle(
                        color: isDestructive
                            ? CupertinoColors.systemRed
                            : cupertinoTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (dialog.icon != null) ...[
            dialog.icon!,
            const SizedBox(height: 12),
          ],
          if (dialog.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                dialog.title!,
                textAlign: titleAlign,
                style: titleStyle,
              ),
            ),
          ConfirmDialogBody(
            message: dialog.message,
            content: dialog.content,
            errorText: errorText,
            textAlign: contentAlign,
            messageColor: messageColor,
            messageTextStyle: s.messageTextStyle,
            errorTextStyle: s.errorTextStyle,
          ),
        ],
      ),
    );
  }

  bool _isErrorVisible(BuildContext context) {
    return errorText != null && errorText!.trim().isNotEmpty;
  }
}