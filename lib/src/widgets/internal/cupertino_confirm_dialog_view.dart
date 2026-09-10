import 'package:flutter/cupertino.dart';

import '../../models/async_confirm_dialog_style.dart';
import '../../models/dialog_platform.dart';
import '../async_confirm_dialog.dart';
import 'async_action_content.dart';
import 'confirm_dialog_body.dart';

/// Cupertino-specific rendering of an [AsyncConfirmDialog].
///
/// Uses real [`CupertinoDialogAction`](https://api.flutter.dev/flutter/cupertino/CupertinoDialogAction-class.html)
/// semantics so default/destructive/disabled states render with authentic
/// platform colours that adapt to light and dark mode.
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

    final titleAlign = s.titleAlign ?? TextAlign.center;
    final contentAlign = s.contentAlign ?? TextAlign.center;

    final accent = isDestructive
        ? (s.destructiveColor ?? CupertinoColors.systemRed)
        : (s.confirmColor ?? cupertinoTheme.primaryColor);

    return CupertinoAlertDialog(
      actions: [
        if (dialog.showCancelButton)
          CupertinoDialogAction(
            isDefaultAction: false,
            isDestructiveAction: false,
            onPressed: isLoading ? null : onCancelPressed,
            textStyle: s.actionTextStyle,
            child: AsyncActionContent(
              label: dialog.cancelText,
              platform: DialogPlatform.cupertino,
              isLoading: false,
              textStyle: s.actionTextStyle,
            ),
          ),
        CupertinoDialogAction(
          isDefaultAction: !isDestructive,
          isDestructiveAction: isDestructive,
          onPressed: isLoading ? null : onConfirmPressed,
          textStyle: s.actionTextStyle,
          child: AsyncActionContent(
            label: dialog.confirmText,
            loadingLabel: dialog.loadingText,
            platform: DialogPlatform.cupertino,
            isLoading: isLoading,
            progressColor: accent,
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
          if (dialog.title != null) ...[
            Text(
              dialog.title!,
              textAlign: titleAlign,
              style: (s.titleTextStyle ??
                      cupertinoTheme.textTheme.textStyle.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ))
                  .copyWith(color: s.titleColor),
            ),
            const SizedBox(height: 4),
          ],
          ConfirmDialogBody(
            message: dialog.message,
            content: dialog.content,
            errorText: errorText,
            textAlign: contentAlign,
            messageColor: s.messageColor ?? CupertinoColors.secondaryLabel,
            messageTextStyle: s.messageTextStyle,
            errorTextStyle: s.errorTextStyle,
            errorColor: CupertinoColors.systemRed,
          ),
        ],
      ),
    );
  }
}