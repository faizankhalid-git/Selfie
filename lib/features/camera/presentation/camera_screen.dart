import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../models/pose_reference.dart';
import '../../../services/camera/camera_service.dart';
import 'native_camera_preview.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});
  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  CameraPermissionStatus _permission = CameraPermissionStatus.unknown;
  bool _frontFacing = true;
  @override
  void initState() {
    super.initState();
    Future.microtask(_requestPermission);
  }

  Future<void> _requestPermission() async {
    final status = await ref.read(cameraServiceProvider).requestPermission();
    if (mounted) setState(() => _permission = status);
  }

  Future<void> _toggleCamera() async {
    setState(() => _frontFacing = !_frontFacing);
    await ref.read(cameraServiceProvider).setLens(frontFacing: _frontFacing);
  }

  @override
  Widget build(BuildContext context) {
    final pose = ModalRoute.of(context)?.settings.arguments as PoseReference?;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_permission == CameraPermissionStatus.granted)
            const NativeCameraPreview()
          else
            _PermissionMessage(
              status: _permission,
              onRetry: _requestPermission,
            ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      color: Colors.white,
                      icon: const Icon(Icons.close_rounded),
                    ),
                    Expanded(
                      child: Text(
                        pose?.name ?? 'Camera',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Live guide preview will appear here',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: _toggleCamera,
                      color: Colors.white,
                      icon: const Icon(Icons.flip_camera_ios_rounded, size: 30),
                    ),
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 5),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionMessage extends StatelessWidget {
  const _PermissionMessage({required this.status, required this.onRetry});
  final CameraPermissionStatus status;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.no_photography_outlined,
          color: Colors.white,
          size: 56,
        ),
        const SizedBox(height: 16),
        Text(
          status == CameraPermissionStatus.denied
              ? 'Camera access is needed to align your pose.'
              : 'Preparing camera…',
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FilledButton(onPressed: onRetry, child: const Text('Allow camera')),
      ],
    ),
  );
}
