import 'package:flutter/material.dart';

/// The body of an [AsyncConfirmDialog], containing the optional message,
/// custom content, and an inline error message.
///
/// This widget is package-internal and shared by the Material and Cupertino
/// views.
class ConfirmDialogBody extends StatelessWidget {
  /// Creates the body for a confirmation dialog.
  const ConfirmDialogBody({
    super.key,
    this.message,
    this.content,
    this.errorText,
    this.textAlign,
    this.messageTextStyle,
    this.messageColor,
    this.errorTextStyle,
    this.errorColor,
  });

  /// Optional descriptive message shown above [content].
  final String? message;

  /// Optional arbitrary content shown below [message].
  final Widget? content;

  /// Optional inline error text shown when an async action fails.
  final String? errorText;

  /// Text alignment for [message] and [errorText].
  final TextAlign? textAlign;

  /// Style applied to [message].
  final TextStyle? messageTextStyle;

  /// Colour applied to [message] when [messageTextStyle] has no colour.
  final Color? messageColor;

  /// Style applied to [errorText].
  final TextStyle? errorTextStyle;

  /// Colour applied to [errorText] when [errorTextStyle] has no colour.
  ///
  /// Defaults to the Material theme's error colour.
  final Color? errorColor;

  /// Whether the body has anything to render.
  bool get isEmpty =>
      (message == null || message!.trim().isEmpty) &&
      content == null &&
      (errorText == null || errorText!.trim().isEmpty);

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final effectiveMessageStyle = (messageTextStyle ??
            DefaultTextStyle.of(context).style)
        .copyWith(color: messageColor);

    final effectiveErrorStyle = (errorTextStyle ??
            theme.textTheme.bodySmall ??
            const TextStyle())
        .copyWith(color: errorColor ?? theme.colorScheme.error);

    final hasMessage = message != null && message!.trim().isNotEmpty;
    final hasError = errorText != null && errorText!.trim().isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasMessage)
          Text(message!, textAlign: textAlign, style: effectiveMessageStyle),
        if (content != null) ...[
          if (hasMessage) const SizedBox(height: 12),
          content!,
        ],
        if (hasError) ...[
          if (hasMessage || content != null) const SizedBox(height: 12),
          Text(errorText!,
              textAlign: textAlign, style: effectiveErrorStyle),
        ],
      ],
    );
  }
}
