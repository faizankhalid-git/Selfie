import '../../models/pose_reference.dart';

abstract interface class PoseRepository {
  Future<List<PoseReference>> loadAll();
  Future<void> save(PoseReference reference);
  Future<void> delete(String id);
}
