import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: const ListTile(
      title: Text('PoseCoach'),
      subtitle: Text('Local-first camera assistant · Phase 1'),
    ),
  );
}
