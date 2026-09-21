import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pose_reference.dart';
import '../services/camera/camera_service.dart';

final cameraServiceProvider = Provider<CameraService>(
  (ref) => NativeCameraService(),
);
final bundledPosesProvider = Provider<List<PoseReference>>(
  (ref) => const [
    PoseReference(
      id: 'standing-welcome',
      name: 'The Welcome',
      category: 'Standing',
      tags: ['solo', 'casual'],
      source: PoseReferenceSource.bundled,
    ),
    PoseReference(
      id: 'walking-forward',
      name: 'Walking Forward',
      category: 'Walking',
      tags: ['solo', 'street'],
      source: PoseReferenceSource.bundled,
    ),
    PoseReference(
      id: 'casual-lean',
      name: 'Casual Lean',
      category: 'Casual',
      tags: ['solo', 'travel'],
      source: PoseReferenceSource.bundled,
    ),
  ],
);
