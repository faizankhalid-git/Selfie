import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../models/pose_reference.dart';

class PoseLibraryScreen extends ConsumerWidget {
  const PoseLibraryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poses = ref.watch(bundledPosesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PoseCoach',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'Choose your pose',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'Stand in the guide and let PoseCoach help you take the shot.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ...poses.map((pose) => _PoseCard(pose: pose)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Import a reference photo'),
          ),
        ],
      ),
    );
  }
}

class _PoseCard extends StatelessWidget {
  const _PoseCard({required this.pose});
  final PoseReference pose;
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 14),
    child: InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Navigator.pushNamed(context, '/camera', arguments: pose),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 74,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E8F8),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.accessibility_new_rounded,
                size: 42,
                color: Color(0xFF5A67D8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pose.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pose.category}  ·  ${pose.tags.join(' · ')}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    ),
  );
}
