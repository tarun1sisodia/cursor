import 'package:flutter/material.dart';

class SentryTestScreen extends StatelessWidget {
  const SentryTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sentry Test')),
      body: const Center(child: Text('Sentry Test Screen')),
    );
  }
}
