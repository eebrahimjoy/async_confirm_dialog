import 'package:async_confirm_dialog/async_confirm_dialog.dart';
import 'package:flutter/material.dart';

/// Main screen with a demo tile for every flavour of confirmation dialog.
class DemoScreen extends StatefulWidget {
  /// Creates the demo screen.
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  String _status = 'Tap a button below to try the dialogs.';
  bool _statusIsError = false;

  void _setStatus(String message, {bool isError = false}) {
    setState(() {
      _status = message;
      _statusIsError = isError;
    });
  }

  /// Simulates an async operation that completes after [delay].
  Future<void> _fakeWork(Duration delay) async {
    await Future<void>.delayed(delay);
  }

  Future<void> _onStandardConfirm() async {
    _setStatus('Working...');
    await _fakeWork(const Duration(seconds: 2));
    _setStatus('Saved successfully.');
  }

  Future<void> _onDelete() async {
    await _fakeWork(const Duration(seconds: 3));
    _setStatus('Note deleted.');
  }

  Future<void> _onSignOut() async {
    _setStatus('Signing out...');
    await _fakeWork(const Duration(seconds: 2));
    _setStatus('Signed out.');
  }

  Future<void> _onFlakyAction() async {
    _setStatus('Attempting...');
    await _fakeWork(const Duration(seconds: 1));
    throw StateError('Flaky server response - could not complete the action.');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Async Confirm Dialog')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _status,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _statusIsError ? colorScheme.error : null,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Standard'),
          _ButtonTile(
            icon: Icons.save_outlined,
            title: 'Save',
            subtitle: 'A simple confirm that returns a bool.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Save changes?',
                message: 'Your edits will be saved and shared with your team.',
                confirmText: 'Save',
                onConfirm: _onStandardConfirm,
              );
              if (confirmed == true) {
                _setStatus('You confirmed the save.');
              } else {
                _setStatus('You cancelled the save.');
              }
            },
          ),
          const SizedBox(height: 8),
          const _SectionTitle('Destructive'),
          _ButtonTile(
            icon: Icons.delete_outline,
            title: 'Delete note',
            subtitle: 'Red confirm button with an inline loading spinner.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Delete this note?',
                message: 'This action cannot be undone.',
                confirmText: 'Delete',
                variant: ConfirmDialogVariant.destructive,
                onConfirm: _onDelete,
                onError: (error, stack) =>
                    _setStatus('Could not delete the note. Please try again.',
                        isError: true),
              );
              if (confirmed == true) {
                _setStatus('The note was deleted.');
              } else {
                _setStatus('Deletion cancelled.');
              }
            },
          ),
          _ButtonTile(
            icon: Icons.logout,
            title: 'Log out',
            subtitle: 'Destructive primary action.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Log out?',
                message: 'You will need to sign in again to continue.',
                confirmText: 'Log out',
                variant: ConfirmDialogVariant.destructive,
                onConfirm: _onSignOut,
              );
              if (confirmed == true) {
                _setStatus('You are now signed out.');
              }
            },
          ),
          const SizedBox(height: 8),
          const _SectionTitle('Async failure handling'),
          _ButtonTile(
            icon: Icons.error_outline,
            title: 'Flaky action',
            subtitle: 'Throws after a delay - the dialog catches it.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Run flaky action?',
                message: 'This demo always fails so you can see the error UI.',
                confirmText: 'Run',
                onConfirm: _onFlakyAction,
                onError: (error, stack) =>
                    _setStatus('The action failed. Please try again.',
                        isError: true),
                errorMessage: 'Something went wrong. Please try again.',
              );
              if (confirmed == true) {
                _setStatus('Action completed.');
              }
            },
          ),
          _ButtonTile(
            icon: Icons.refresh,
            title: 'Retry after failure',
            subtitle: 'dismissOnError closes the dialog when the action throws.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Sync now?',
                message: 'Syncing may fail if the network is down.',
                confirmText: 'Sync',
                onConfirm: _onFlakyAction,
                dismissOnError: true,
                onError: (error, stack) => _setStatus(
                  'Sync failed and the dialog closed.',
                  isError: true,
                ),
              );
              if (confirmed == true) {
                _setStatus('Synced.');
              }
            },
          ),
          const SizedBox(height: 8),
          const _SectionTitle('Customization'),
          _ButtonTile(
            icon: Icons.palette_outlined,
            title: 'Custom styled',
            subtitle: 'Custom colors, corners, and icon.',
            onTap: () async {
              final confirmed = await AppDialog.confirm(
                context,
                icon: const Icon(Icons.star, color: Colors.teal),
                title: 'Custom style',
                message: 'This dialog uses a custom style and icon.',
                confirmText: 'Looks good',
                style: AsyncConfirmDialogStyle(
                  confirmColor: Colors.teal,
                  borderRadius: BorderRadius.circular(24),
                ),
                onConfirm: () async => _setStatus('Custom dialog confirmed.'),
              );
              if (confirmed == true) {
                _setStatus('You liked the custom dialog.');
              }
            },
          ),
          _ButtonTile(
            icon: Icons.phone_iphone,
            title: 'Cupertino style',
            subtitle: 'Native CupertinoDialogAction controls.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Cupertino look',
                message: 'Rendered with real CupertinoDialogAction buttons.',
                confirmText: 'OK',
                platform: DialogPlatform.cupertino,
              );
              if (confirmed == true) {
                _setStatus('Cupertino dialog confirmed.');
              }
            },
          ),
          _ButtonTile(
            icon: Icons.favorite_border,
            title: 'With icon',
            subtitle: 'A custom icon sits above the title.',
            onTap: () async {
              final confirmed = await AppDialog.confirm(
                context,
                icon: const Icon(Icons.favorite, color: Colors.pink),
                title: 'Free trial ending?',
                message: 'Your free trial ends in two days.',
                confirmText: 'Keep me updated',
              );
              if (confirmed == true) {
                _setStatus('You will be notified.');
              }
            },
          ),
          _ButtonTile(
            icon: Icons.not_interested,
            title: 'No cancel button',
            subtitle: 'Forced choice; only the confirm action is shown.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Enable notifications?',
                message: 'You can change this later in Settings.',
                confirmText: 'Enable',
                showCancelButton: false,
                barrierDismissible: false,
              );
              if (confirmed == true) {
                _setStatus('Notifications enabled.');
              }
            },
          ),
          _ButtonTile(
            icon: Icons.timer_outlined,
            title: 'Loading label',
            subtitle: 'Custom text next to the spinner.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Generate report?',
                message: 'This can take a few seconds.',
                confirmText: 'Generate',
                loadingText: 'Generating...',
                onConfirm: () => _fakeWork(const Duration(seconds: 3)),
              );
              if (confirmed == true) {
                _setStatus('Report generated.');
              }
            },
          ),
          const SizedBox(height: 8),
          const _SectionTitle('Custom content'),
          _ButtonTile(
            icon: Icons.widgets_outlined,
            title: 'Embedded widget',
            subtitle: 'Any widget can be placed in the dialog body.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Publish?',
                message: 'Do you want to publish these changes?',
                confirmText: 'Publish',
                content: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Private note - visible to teammates'),
                ),
              );
              if (confirmed == true) {
                _setStatus('Published.');
              }
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _ButtonTile extends StatelessWidget {
  const _ButtonTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}