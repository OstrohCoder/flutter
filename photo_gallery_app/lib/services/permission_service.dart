import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) return PermissionStatus.granted;
    if (status.isDenied) return await Permission.camera.request();
    if (status.isPermanentlyDenied) return PermissionStatus.permanentlyDenied;

    return status;
  }

  Future<PermissionStatus> requestGalleryPermission() async {
    final status = await Permission.photos.status;

    if (status.isGranted || status.isLimited) return status;
    if (status.isDenied) return await Permission.photos.request();
    if (status.isPermanentlyDenied) return PermissionStatus.permanentlyDenied;

    return status;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}
