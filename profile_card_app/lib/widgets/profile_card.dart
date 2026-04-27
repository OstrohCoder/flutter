import 'package:flutter/material.dart';

import '../screens/profile_detail_screen.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String profession;
  final String phone;
  final String email;
  final String location;

  const ProfileCard({
    super.key,
    required this.name,
    required this.profession,
    required this.phone,
    required this.email,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileDetailScreen(),
                    ),
                  );
                },
                child: Hero(
                  tag: 'profile-avatar',
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                profession,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),

              const SizedBox(height: 24),

              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _ContactInfo(icon: Icons.phone, text: phone),
                    _ContactInfo(icon: Icons.email, text: email),
                    _ContactInfo(icon: Icons.location_on, text: location),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.link),
                    tooltip: 'Website',
                    onPressed: () => debugPrint('Website'),
                  ),
                  IconButton(
                    icon: Icon(Icons.chat),
                    tooltip: 'Telegram',
                    onPressed: () => debugPrint('Telegram'),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo_camera),
                    tooltip: 'Instagram',
                    onPressed: () => debugPrint('Instagram'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit Profile clicked')),
                    );
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),

          const SizedBox(width: 12),

          Text(text, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
