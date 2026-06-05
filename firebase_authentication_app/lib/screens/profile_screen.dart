import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view profile')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(child: Text('Email: ${user.email}')),
    );
  }
}
