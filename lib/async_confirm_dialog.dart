/// An async-aware confirmation dialog for Flutter.
///
/// Show a confirmation dialog with zero boilerplate and have the confirm
/// button automatically manage loading states, double-tap prevention, and
/// error handling for you.
///
/// ```dart
/// final confirmed = await AppDialog.confirm(
///   context,
///   title: 'Delete note?',
///   onConfirm: () => notesRepository.remove(id),
/// );
/// ```
library;

export 'src/app_dialog.dart';
export 'src/models/async_confirm_dialog_style.dart';
export 'src/models/confirm_dialog_variant.dart';
export 'src/models/dialog_platform.dart';
export 'src/widgets/async_confirm_dialog.dart';