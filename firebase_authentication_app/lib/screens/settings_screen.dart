import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view settings')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings')),
    );
  }
}
