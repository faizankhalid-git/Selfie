import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/pose_reference.dart';
import 'pose_repository.dart';

class LocalPoseRepository implements PoseRepository {
  LocalPoseRepository(this._preferences);
  static const _key = 'pose_references';
  final SharedPreferences _preferences;

  @override
  Future<List<PoseReference>> loadAll() async {
    final values = _preferences.getStringList(_key) ?? <String>[];
    return values
        .map((value) {
          final data = jsonDecode(value) as Map<String, dynamic>;
          return PoseReference(
            id: data['id'] as String,
            name: data['name'] as String,
            category: data['category'] as String,
            tags: (data['tags'] as List<dynamic>).cast<String>(),
            source: PoseReferenceSource.values.firstWhere(
              (item) => item.name == data['source'],
              orElse: () => PoseReferenceSource.userImported,
            ),
          );
        })
        .toList(growable: false);
  }

  @override
  Future<void> save(PoseReference reference) async {
    final values = _preferences.getStringList(_key) ?? <String>[];
    values.add(
      jsonEncode({
        'id': reference.id,
        'name': reference.name,
        'category': reference.category,
        'tags': reference.tags,
        'source': reference.source.name,
      }),
    );
    await _preferences.setStringList(_key, values);
  }

  @override
  Future<void> delete(String id) async {
    final values = _preferences.getStringList(_key) ?? <String>[];
    await _preferences.setStringList(
      _key,
      values.where((value) => jsonDecode(value)['id'] != id).toList(),
    );
  }
}
