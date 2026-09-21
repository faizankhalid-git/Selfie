import '../../models/pose_model.dart';

class DetectedPose {
  const DetectedPose({
    required this.pose,
    required this.timestamp,
    required this.confidence,
  });
  final PoseModel pose;
  final DateTime timestamp;
  final double confidence;
}

abstract interface class PoseEngine {
  Future<void> initialize();
  Stream<DetectedPose> get poseStream;
  Future<PoseModel?> detectPoseFromImage(String imagePath);
  Future<void> dispose();
}
