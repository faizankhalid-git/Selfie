import '../../models/pose_match_result.dart';
import '../../models/pose_model.dart';

class PoseMatchingConfiguration {
  const PoseMatchingConfiguration({
    this.alignmentThreshold = .82,
    this.confidenceThreshold = .55,
    this.stabilityDuration = const Duration(milliseconds: 700),
  });
  final double alignmentThreshold;
  final double confidenceThreshold;
  final Duration stabilityDuration;
}

abstract interface class PoseMatcher {
  PoseMatchResult match(PoseModel reference, PoseModel detected);
}
