import 'package:flutter/material.dart';

import '../widgets/profile_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ProfileCard(
              name: 'Даниїл Лізак',
              profession: 'Flutter Developer',
              phone: '+380 12 345 67 89',
              email: 'danyil.lizak@oa.edu.ua',
              location: 'с. Хорів, Острожчина',
            ),
          ),
        ),
      ),
    );
  }
}
