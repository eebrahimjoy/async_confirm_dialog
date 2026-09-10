import 'package:flutter/material.dart';

/// Selects the design language used to render an [AsyncConfirmDialog].
///
/// Most applications only ever need [DialogPlatform.adaptive], which matches
/// the running platform. The other values force a specific look and are useful
/// for previews, tests, or apps that intentionally use a single design
/// language across platforms.
enum DialogPlatform {
  /// Renders a Material 3 [`AlertDialog`](https://api.flutter.dev/flutter/material/AlertDialog-class.html).
  material,

  /// Renders a [`CupertinoAlertDialog`](https://api.flutter.dev/flutter/cupertino/CupertinoAlertDialog-class.html).
  cupertino,

  /// Automatically picks [material] or [cupertino] based on the ambient
  /// [ThemeData.platform].
  adaptive;

  /// Resolves this value into a concrete platform using [context].
  ///
  /// For [DialogPlatform.adaptive] this inspects [ThemeData.platform] and
  /// returns [DialogPlatform.cupertino] on iOS and macOS, and
  /// [DialogPlatform.material] everywhere else. The concrete values are
  /// returned unchanged.
  DialogPlatform resolve(BuildContext context) {
    if (this != DialogPlatform.adaptive) {
      return this;
    }
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return DialogPlatform.cupertino;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return DialogPlatform.material;
    }
  }
}
