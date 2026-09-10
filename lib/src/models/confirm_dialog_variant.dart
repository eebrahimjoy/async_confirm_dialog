/// Describes the intent of a confirmation dialog.
///
/// The variant is a semantic hint rather than a hard style: it tells the
/// dialog how to colour and label the primary action.
enum ConfirmDialogVariant {
  /// A regular, non-destructive action (for example "Save" or "Continue").
  normal,

  /// A potentially destructive action (for example "Delete" or "Log out").
  ///
  /// When set, the confirm button is rendered by default with the theme's
  /// error colour and, on Cupertino, as a destructive dialog action.
  destructive;

  /// Whether this variant represents a destructive action.
  bool get isDestructive => this == ConfirmDialogVariant.destructive;
}
