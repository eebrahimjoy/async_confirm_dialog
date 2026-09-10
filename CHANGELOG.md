## 1.0.2

- Compress the demo GIFs so they render in the README on GitHub and pub.dev.

## 1.0.1

- Confirm action is now a filled button with computed text contrast so its
  label stays readable on any surface colour.
- Cupertino view uses native `CupertinoDialogAction` semantics and dynamic
  platform colours that adapt to light and dark mode.
- Error text strips exception prefixes (`Bad state:`, `Exception:`) and falls
  back to a friendly message; a throwing `onError` handler can no longer
  break the dialog.
- Exclude demo GIFs and build artifacts from the published package; the
  README links to them via GitHub raw URLs.
- Expand the example app with customization, retry-on-failure, and custom
  content demos; add `errorColor` to the dialog body and more widget tests.

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