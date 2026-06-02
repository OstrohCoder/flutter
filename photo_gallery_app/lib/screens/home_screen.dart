import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/permission_service.dart';
import 'photo_detail_screen.dart';
import '../widgets/permission_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final PermissionService _permissionService = PermissionService();
  List<String> _imagePaths = [];
  bool _isLoading = false;
  Widget? _permissionWidget;

  @override
  void initState() {
    super.initState();
    _loadPathsList();
  }

  void _showSettingsDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permissionName Permission'),
        content: Text(
          '$permissionName permission is permanently denied. '
          'Please enable it in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _permissionService.openSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    final permission = await _permissionService.requestCameraPermission();

    if (!permission.isGranted) {
      setState(() {
        _permissionWidget = permission.isPermanentlyDenied
            ? const PermissionPermanentlyDeniedWidget(permissionName: 'Camera')
            : PermissionDeniedWidget(
                permissionName: 'Camera',
                onRequestAgain: _pickImageFromCamera,
              );
      });

      return;
    }

    setState(() {
      _permissionWidget = null;
    });

    setState(() => _isLoading = true);

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final savedPath = await _saveImage(image);
        setState(() => _imagePaths.add(savedPath));
        await _savePathsList();

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Photo saved!')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImageFromGallery() async {
    final permission = await _permissionService.requestGalleryPermission();

    if (!permission.isGranted && !permission.isLimited) {
      setState(() {
        _permissionWidget = permission.isPermanentlyDenied
            ? const PermissionPermanentlyDeniedWidget(permissionName: 'Gallery')
            : PermissionDeniedWidget(
                permissionName: 'Gallery',
                onRequestAgain: _pickImageFromGallery,
              );
      });

      return;
    }

    setState(() {
      _permissionWidget = null;
    });

    setState(() => _isLoading = true);

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final savedPath = await _saveImage(image);
        setState(() => _imagePaths.add(savedPath));
        await _savePathsList();

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Photo saved!')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _saveImage(XFile image) async {
    final directory = await getApplicationDocumentsDirectory();

    final photosDir = Directory('${directory.path}/photos');
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = path.join(photosDir.path, fileName);

    await File(image.path).copy(filePath);

    return filePath;
  }

  Future<void> _savePathsList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('image_paths', _imagePaths);
  }

  Future<void> _loadPathsList() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = prefs.getStringList('image_paths') ?? [];
    setState(() => _imagePaths = paths);
  }

  void _openFullScreen(String imagePath, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetailScreen(
          imagePath: imagePath,
          index: index,
          onDelete: () async => await _deletePhoto(index),
        ),
      ),
    );
  }

  Future<void> _deletePhoto(int index) async {
    final imagePath = _imagePaths[index];

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }

      setState(() => _imagePaths.removeAt(index));
      await _savePathsList();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Photo deleted')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting photo: $e')));
      }
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 100, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No photos yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add photos',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _imagePaths.length,
      itemBuilder: (context, index) {
        final imagePath = _imagePaths[index];
        return Dismissible(
          key: Key(imagePath),
          direction: DismissDirection.up,
          onDismissed: (_) => _deletePhoto(index),
          background: Container(
            color: Colors.red,
            alignment: Alignment.center,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: GestureDetector(
            onTap: () => _openFullScreen(imagePath, index),
            child: Hero(
              tag: 'photo_$index',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Photos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _showImageSourceBottomSheet,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _permissionWidget != null
          ? _permissionWidget!
          : _imagePaths.isEmpty
          ? _buildEmptyState()
          : _buildGridView(),
    );
  }
}
