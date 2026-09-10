import 'package:flutter/material.dart';

import 'screens/demo_screen.dart';

/// Demo application for the [async_confirm_dialog] package.
void main() => runApp(const DemoApp());

/// The root widget of the demo application.
class DemoApp extends StatelessWidget {
  /// Creates the demo application root.
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Async Confirm Dialog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const DemoScreen(),
    );
  }
}