import 'dart:async';

import 'package:async_confirm_dialog/async_confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Arguments forwarded to [AppDialog.confirm] by a test helper.
class DialogArgs {
  const DialogArgs({
    this.title = 'Delete?',
    this.message = 'Are you sure?',
    this.confirmText = 'Delete',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onError,
    this.variant = ConfirmDialogVariant.normal,
    this.platform = DialogPlatform.material,
    this.dismissOnError = false,
    this.errorMessage,
  });

  final String title;
  final String? message;
  final String confirmText;
  final String cancelText;
  final Future<void> Function()? onConfirm;
  final void Function(Object, StackTrace)? onError;
  final ConfirmDialogVariant variant;
  final DialogPlatform platform;
  final bool dismissOnError;
  final String? errorMessage;
}

Future<bool?> Function() openDialog(WidgetTester tester,
    {required DialogArgs args}) {
  return () => AppDialog.confirm(
        _contextOf(),
        title: args.title,
        message: args.message,
        confirmText: args.confirmText,
        cancelText: args.cancelText,
        onConfirm: args.onConfirm,
        onError: args.onError,
        variant: args.variant,
        platform: args.platform,
        dismissOnError: args.dismissOnError,
        errorMessage: args.errorMessage,
      );
}

void main() {
  testWidgets('shows title and message', (tester) async {
    await tester.pumpWidget(_buildApp());

    final future = openDialog(tester, args: const DialogArgs())();
    await tester.pumpAndSettle();

    expect(find.text('Delete?'), findsOneWidget);
    expect(find.text('Are you sure?'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await future, isFalse);
  });

  testWidgets('returns true when confirmed without an async action',
      (tester) async {
    await tester.pumpWidget(_buildApp());

    final future = openDialog(tester, args: const DialogArgs())();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(await future, isTrue);
  });

  testWidgets('returns false when cancelled', (tester) async {
    await tester.pumpWidget(_buildApp());

    final future = openDialog(tester, args: const DialogArgs())();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(await future, isFalse);
  });

  testWidgets(
      'switches confirm button to loading and blocks interaction while busy',
      (tester) async {
    final completer = Completer<void>();
    await tester.pumpWidget(_buildApp());

    final future = openDialog(
      tester,
      args: DialogArgs(onConfirm: () => completer.future),
    )();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pump();

    // Confirm label is gone, replaced by a progress indicator.
    expect(find.text('Delete'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete();
    await tester.pumpAndSettle();

    expect(await future, isTrue);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(
      'shows inline error and keeps dialog open when async action throws',
      (tester) async {
    await tester.pumpWidget(_buildApp());

    Object? capturedError;
    final future = openDialog(
      tester,
      args: DialogArgs(
        onConfirm: () async => throw StateError('anything'),
        onError: (Object e, StackTrace s) => capturedError = e,
        errorMessage: 'Action failed. Try again.',
      ),
    )();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(capturedError, isA<StateError>());
    expect(find.text('Action failed. Try again.'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await future, isFalse);
  });

  testWidgets('dismisses with false when dismissOnError is true on failure',
      (tester) async {
    await tester.pumpWidget(_buildApp());

    final future = openDialog(
      tester,
      args: DialogArgs(
        onConfirm: () async => throw StateError('anything'),
        dismissOnError: true,
      ),
    )();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(await future, isFalse);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('renders the Cupertino dialog when platform is cupertino',
      (tester) async {
    await tester.pumpWidget(_buildApp());

    final future = openDialog(
      tester,
      args: const DialogArgs(platform: DialogPlatform.cupertino),
    )();
    await tester.pumpAndSettle();

    expect(find.byType(CupertinoAlertDialog), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await future, isFalse);
  });
}

BuildContext? _contextHolder;

BuildContext _contextOf() => _contextHolder!;

Widget _buildApp() {
  return MaterialApp(
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
    home: Builder(
      builder: (context) {
        _contextHolder = context;
        return const Scaffold(body: SizedBox());
      },
    ),
  );
}