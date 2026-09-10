import 'package:flutter/material.dart';

/// Visual overrides for an [AsyncConfirmDialog].
///
/// Every field is optional. When a field is `null` the dialog falls back to
/// the ambient [ThemeData] (Material) or [CupertinoThemeData] (Cupertino), so
/// the widget blends into the host application by default.
///
/// ```dart
/// AsyncConfirmDialogStyle(
///   confirmColor: Colors.deepPurple,
///   titleTextStyle: TextStyle(fontWeight: FontWeight.w800),
///   borderRadius: BorderRadius.circular(24),
/// )
/// ```
@immutable
class AsyncConfirmDialogStyle {
  /// Creates a set of visual overrides for an [AsyncConfirmDialog].
  const AsyncConfirmDialogStyle({
    this.backgroundColor,
    this.titleColor,
    this.messageColor,
    this.confirmColor,
    this.cancelColor,
    this.destructiveColor,
    this.titleTextStyle,
    this.messageTextStyle,
    this.actionTextStyle,
    this.errorTextStyle,
    this.borderRadius,
    this.elevation,
    this.titleAlign,
    this.contentAlign,
    this.contentPadding,
    this.actionsPadding,
  });

  /// Background colour of the dialog surface.
  ///
  /// Only applied on Material. Cupertino dialogs use their platform blur.
  final Color? backgroundColor;

  /// Colour applied to the title when no explicit style is supplied.
  final Color? titleColor;

  /// Colour applied to the message/body text when no explicit style is supplied.
  final Color? messageColor;

  /// Colour applied to the confirm action for [ConfirmDialogVariant.normal].
  final Color? confirmColor;

  /// Colour applied to the cancel action.
  final Color? cancelColor;

  /// Colour applied to the confirm action for
  /// [ConfirmDialogVariant.destructive]. Defaults to the theme error colour.
  final Color? destructiveColor;

  /// Explicit text style for the title. Overrides [titleColor].
  final TextStyle? titleTextStyle;

  /// Explicit text style for the message/body. Overrides [messageColor].
  final TextStyle? messageTextStyle;

  /// Explicit text style for the action buttons. Overrides the action colours.
  final TextStyle? actionTextStyle;

  /// Text style used to render inline error messages.
  final TextStyle? errorTextStyle;

  /// Corner radius of the Material dialog surface.
  final BorderRadiusGeometry? borderRadius;

  /// Elevation of the Material dialog surface.
  final double? elevation;

  /// Horizontal alignment of the title. Defaults to `start` on Material and
  /// `center` on Cupertino.
  final TextAlign? titleAlign;

  /// Alignment of the message and inline error text. Defaults to `start` on
  /// Material and `center` on Cupertino.
  final TextAlign? contentAlign;

  /// Padding around the dialog content.
  final EdgeInsetsGeometry? contentPadding;

  /// Padding around the dialog actions.
  final EdgeInsetsGeometry? actionsPadding;

  /// Returns a copy of this style with the given fields replaced.
  AsyncConfirmDialogStyle copyWith({
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
    Color? confirmColor,
    Color? cancelColor,
    Color? destructiveColor,
    TextStyle? titleTextStyle,
    TextStyle? messageTextStyle,
    TextStyle? actionTextStyle,
    TextStyle? errorTextStyle,
    BorderRadiusGeometry? borderRadius,
    double? elevation,
    TextAlign? titleAlign,
    TextAlign? contentAlign,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
  }) {
    return AsyncConfirmDialogStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleColor: titleColor ?? this.titleColor,
      messageColor: messageColor ?? this.messageColor,
      confirmColor: confirmColor ?? this.confirmColor,
      cancelColor: cancelColor ?? this.cancelColor,
      destructiveColor: destructiveColor ?? this.destructiveColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      messageTextStyle: messageTextStyle ?? this.messageTextStyle,
      actionTextStyle: actionTextStyle ?? this.actionTextStyle,
      errorTextStyle: errorTextStyle ?? this.errorTextStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      titleAlign: titleAlign ?? this.titleAlign,
      contentAlign: contentAlign ?? this.contentAlign,
      contentPadding: contentPadding ?? this.contentPadding,
      actionsPadding: actionsPadding ?? this.actionsPadding,
    );
  }

  /// Linearly interpolates between two [AsyncConfirmDialogStyle]s.
  static AsyncConfirmDialogStyle lerp(
    AsyncConfirmDialogStyle? a,
    AsyncConfirmDialogStyle? b,
    double t,
  ) {
    if (a == null && b == null) {
      return const AsyncConfirmDialogStyle();
    }
    if (a == null) {
      return b!;
    }
    if (b == null) {
      return a;
    }
    return AsyncConfirmDialogStyle(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      titleColor: Color.lerp(a.titleColor, b.titleColor, t),
      messageColor: Color.lerp(a.messageColor, b.messageColor, t),
      confirmColor: Color.lerp(a.confirmColor, b.confirmColor, t),
      cancelColor: Color.lerp(a.cancelColor, b.cancelColor, t),
      destructiveColor: Color.lerp(a.destructiveColor, b.destructiveColor, t),
      titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
      messageTextStyle:
          TextStyle.lerp(a.messageTextStyle, b.messageTextStyle, t),
      actionTextStyle: TextStyle.lerp(a.actionTextStyle, b.actionTextStyle, t),
      errorTextStyle: TextStyle.lerp(a.errorTextStyle, b.errorTextStyle, t),
      borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t),
      elevation: _lerpDouble(a.elevation, b.elevation, t),
      titleAlign: t < 0.5 ? a.titleAlign : b.titleAlign,
      contentAlign: t < 0.5 ? a.contentAlign : b.contentAlign,
      contentPadding:
          EdgeInsetsGeometry.lerp(a.contentPadding, b.contentPadding, t),
      actionsPadding:
          EdgeInsetsGeometry.lerp(a.actionsPadding, b.actionsPadding, t),
    );
  }

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    if (a == null) {
      return b;
    }
    if (b == null) {
      return a;
    }
    return a + (b - a) * t;
  }
}
