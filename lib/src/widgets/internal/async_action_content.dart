import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/dialog_platform.dart';

/// The content of a confirm/cancel action that swaps its label for a progress
/// indicator while [isLoading] is `true`.
///
/// This widget is package-internal and is shared by both the Material and
/// Cupertino dialog views so that the loading affordance is identical.
class AsyncActionContent extends StatelessWidget {
  /// Creates the visual content for a single dialog action button.
  const AsyncActionContent({
    super.key,
    required this.label,
    required this.isLoading,
    required this.platform,
    this.loadingLabel,
    this.textStyle,
    this.progressColor,
    this.progressSize = 18,
  });

  /// The text shown when the action is idle.
  final String label;

  /// Whether this action is currently executing an async operation.
  final bool isLoading;

  /// The resolved platform, used to pick the progress indicator flavour.
  final DialogPlatform platform;

  /// Optional text shown next to the progress indicator while loading.
  final String? loadingLabel;

  /// Optional text style for [label] and [loadingLabel].
  final TextStyle? textStyle;

  /// Optional colour for the progress indicator.
  final Color? progressColor;

  /// The diameter of the progress indicator.
  final double progressSize;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return Text(label, style: textStyle);
    }

    final indicator = platform == DialogPlatform.cupertino
        ? SizedBox(
            height: progressSize,
            width: progressSize,
            child: CupertinoActivityIndicator(
              radius: progressSize / 2.5,
              color: progressColor,
            ),
          )
        : SizedBox(
            height: progressSize,
            width: progressSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );

    final text = loadingLabel;
    if (text == null || text.isEmpty) {
      return indicator;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        indicator,
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
