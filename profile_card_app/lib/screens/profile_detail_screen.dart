import 'package:flutter/material.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Detail')),
      body: Center(
        child: Hero(
          tag: 'profile-avatar',
          child: CircleAvatar(
            radius: 120,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.person, size: 120, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
