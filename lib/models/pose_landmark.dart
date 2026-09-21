enum PoseLandmarkType {
  nose,
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftHip,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
}

class PoseLandmark {
  const PoseLandmark({
    required this.type,
    required this.x,
    required this.y,
    this.z = 0,
    this.confidence = 1,
  });
  final PoseLandmarkType type;
  final double x;
  final double y;
  final double z;
  final double confidence;
}
