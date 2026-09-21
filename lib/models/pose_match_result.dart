class PoseMatchResult {
  const PoseMatchResult({
    required this.overallScore,
    required this.isAligned,
    this.corrections = const [],
  });
  final double overallScore;
  final bool isAligned;
  final List<String> corrections;
}
