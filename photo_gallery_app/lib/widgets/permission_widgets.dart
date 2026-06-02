import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDeniedWidget extends StatelessWidget {
  final String permissionName;
  final VoidCallback onRequestAgain;

  const PermissionDeniedWidget({
    super.key,
    required this.permissionName,
    required this.onRequestAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber, size: 80, color: Colors.orange),
            const SizedBox(height: 24),
            Text(
              '$permissionName Permission Required',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'This app needs $permissionName permission to function properly.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRequestAgain,
              icon: const Icon(Icons.check_circle),
              label: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionPermanentlyDeniedWidget extends StatelessWidget {
  final String permissionName;

  const PermissionPermanentlyDeniedWidget({
    super.key,
    required this.permissionName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.block, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              '$permissionName Permission Denied',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'You have permanently denied $permissionName permission. Please enable it in Settings.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: openAppSettings,
              icon: const Icon(Icons.settings),
              label: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
