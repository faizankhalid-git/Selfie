import '../../models/pose_model.dart';

abstract interface class PoseNormalizer {
  PoseModel normalize(PoseModel pose);
}
