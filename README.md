# Async Confirm Dialog

[![pub package](https://img.shields.io/pub/v/async_confirm_dialog.svg)](https://pub.dev/packages/async_confirm_dialog)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A zero-boilerplate, async-aware confirmation dialog for Flutter.

Every Flutter developer writes confirmation dialogs that tie into asynchronous
APIs: deletes, logouts, saves, updates. Standard dialogs force you to manually
manage loading states, disable buttons, and guard against double-taps. This
package handles all of that for you.

## Demo

The example app running on iOS:

| Demo 1 | Demo 2 |
| ------ | ------ |
| ![async_confirm_dialog demo](https://raw.githubusercontent.com/eebrahimjoy/async_confirm_dialog/main/assets/gif/example1.gif) | ![async_confirm_dialog demo](https://raw.githubusercontent.com/eebrahimjoy/async_confirm_dialog/main/assets/gif/example2.gif) |

Tap any tile in the example to try the dialogs: standard confirms, destructive
actions, async failures, and fully custom styles.

## Highlights

- Zero-boilerplate API. One call returns a `Future<bool?>`.
- Native async support. Pass an `onConfirm` callback and the confirm button
  automatically shows a spinner, disables the cancel action, suppresses
  back/barrier dismissal, and blocks double-taps.
- Graceful error handling. A thrown async action keeps the dialog open, shows
  an inline error, and lets the user retry.
- Material and Cupertino. Adapts to the platform theme automatically or can be
  forced manually.
- Deeply customizable. A rich `AsyncConfirmDialogStyle` for colors, typography,
  corners, padding, and layout.

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  async_confirm_dialog: ^1.0.0
```

Then run:

```sh
flutter pub get
```

## Quick start

Show a dialog and act on the result:

```dart
import 'package:async_confirm_dialog/async_confirm_dialog.dart';

final confirmed = await AppDialog.confirm(
  context,
  title: 'Delete this note?',
  message: 'This action cannot be undone.',
  variant: ConfirmDialogVariant.destructive,
  onConfirm: () => notesRepository.remove(id),
);

if (confirmed == true) {
  // Success path.
}
```

A builder-style extension is also available:

```dart
final ok = await context.confirm(
  title: 'Log out?',
  message: 'You will need to sign in again.',
  variant: ConfirmDialogVariant.destructive,
  onConfirm: () => auth.signOut(),
);
```

## Async lifecycle

When `onConfirm` is supplied, the dialog transitions into a loading state on
tap:

1. The confirm button is replaced by a progress indicator.
2. The cancel action is disabled.
3. Back navigation and barrier dismissal are suppressed.
4. Further taps on the confirm action are ignored.

On success the dialog pops with `true` (unless `dismissOnConfirm: false`). On
failure the loading state clears, `onError` fires, and an inline error is shown
so the user can retry.

```dart
final ok = await AppDialog.confirm(
  context,
  title: 'Run report?',
  confirmText: 'Run',
  onConfirm: generateReport,
  onError: (error, stack) => log.severe('Report failed: $error'),
  errorMessage: 'We could not generate the report. Please try again.',
);
```

## Customization

Force a design language:

```dart
AppDialog.confirm(
  context,
  title: 'Confirm',
  platform: DialogPlatform.cupertino, // DialogPlatform.material or .adaptive
);
```

Style the dialog with `AsyncConfirmDialogStyle`:

```dart
AppDialog.confirm(
  context,
  title: 'Careful',
  variant: ConfirmDialogVariant.destructive,
  style: AsyncConfirmDialogStyle(
    confirmColor: Colors.amber,
    destructiveColor: Colors.red,
    borderRadius: BorderRadius.circular(20),
    contentAlign: TextAlign.center,
  ),
);
```

The returned values:

| Result  | Meaning                                                          |
| ------- | ---------------------------------------------------------------- |
| `true`  | The user confirmed.                                              |
| `false` | The user cancelled, or the action failed with `dismissOnError`.  |
| `null`  | The dialog was dismissed (for example a barrier tap, if enabled). |

## Example

The `example/` directory contains a runnable app covering standard,
destructive, async-failure, and fully custom dialogs. It is configured for both
iOS and Android:

```sh
cd example
flutter run
```

## Author and Contact

Developed and maintained by **Ebrahim Joy**.

- Email: [eebrahimjoy@gmail.com](mailto:eebrahimjoy@gmail.com)
- Website: [eebrahimjoy.com](https://eebrahimjoy.com)
- GitHub: [@eebrahimjoy](https://github.com/eebrahimjoy)

## Contributing

Please report bugs and request features through the
[issue tracker](https://github.com/eebrahimjoy/async_confirm_dialog/issues).
Pull requests are welcome.

## License

Released under the [MIT License](LICENSE).
