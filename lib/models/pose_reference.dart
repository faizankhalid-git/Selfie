import 'pose_model.dart';

enum PoseReferenceSource { bundled, userImported }

class PoseReference {
  const PoseReference({
    required this.id,
    required this.name,
    required this.category,
    required this.tags,
    required this.source,
    this.thumbnailPath,
    this.overlayPath,
    this.normalizedPose,
  });
  final String id;
  final String name;
  final String category;
  final List<String> tags;
  final PoseReferenceSource source;
  final String? thumbnailPath;
  final String? overlayPath;
  final PoseModel? normalizedPose;
}
