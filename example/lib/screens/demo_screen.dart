import 'package:async_confirm_dialog/async_confirm_dialog.dart';
import 'package:flutter/material.dart';

/// Main screen that lets the user trigger each flavour of confirmation dialog.
class DemoScreen extends StatefulWidget {
  /// Creates the demo screen.
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  String _status = 'Tap a button below to try the dialogs.';

  void _setStatus(String message, {bool isError = false}) {
    setState(() {
      _status = message;
    });
  }

  /// Simulates an async operation that takes [delay].
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
                style: Theme.of(context).textTheme.bodyMedium,
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
                message:
                    'Your edits will be saved and shared with your team.',
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
            subtitle: 'Shown in red, with a loading spinner in the button.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Delete this note?',
                message: 'This action cannot be undone.',
                confirmText: 'Delete',
                variant: ConfirmDialogVariant.destructive,
                onConfirm: _onDelete,
                onError: (error, stack) =>
                    _setStatus('Delete failed: $error', isError: true),
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
            subtitle:
                'Throws after a delay - the dialog catches it and stays open.',
            onTap: () async {
              final confirmed = await context.confirm(
                title: 'Run flaky action?',
                message: 'This demo always fails so you can see the error UI.',
                confirmText: 'Run',
                onConfirm: _onFlakyAction,
                onError: (error, stack) =>
                    _setStatus('Action failed: $stack', isError: true),
                errorMessage: 'Something went wrong. Please try again.',
              );
              if (confirmed == true) {
                _setStatus('Action completed.');
              }
            },
          ),
          const SizedBox(height: 8),
          const _SectionTitle('Fully custom'),
          _ButtonTile(
            icon: Icons.palette_outlined,
            title: 'Custom styled',
            subtitle: 'Uses a custom AsyncConfirmDialogStyle.',
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