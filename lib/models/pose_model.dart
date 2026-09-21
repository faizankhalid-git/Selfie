import 'pose_landmark.dart';

class PoseModel {
  const PoseModel({
    required this.landmarks,
    this.jointAngles = const {},
    this.boundingBox,
    this.bodyScale = 1,
  });
  final List<PoseLandmark> landmarks;
  final Map<String, double> jointAngles;
  final ({double left, double top, double right, double bottom})? boundingBox;
  final double bodyScale;
}
