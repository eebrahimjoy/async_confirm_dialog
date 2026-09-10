## 1.0.0

- Initial release.
- `AppDialog.confirm(...)` static helper returning a `Future<bool?>`.
- `BuildContext.confirm(...)` extension alias.
- Built-in async `onConfirm` support with loading state, double-tap
  prevention, and disabled interactions while busy.
- Graceful error handling: stays open, shows an inline error, and supports an
  `onError` callback and `dismissOnError` option.
- Adaptive Material & Cupertino rendering via `DialogPlatform`.
- Rich `AsyncConfirmDialogStyle` for full visual customisation.
- Destructive variant via `ConfirmDialogVariant.destructive`.
- Full documentation, widget tests, and a runnable example app.