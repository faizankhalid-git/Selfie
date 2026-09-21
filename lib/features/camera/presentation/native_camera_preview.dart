import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeCameraPreview extends StatelessWidget {
  const NativeCameraPreview({super.key});
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(
        child: Text('Camera preview is supported on iOS and Android.'),
      );
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => const UiKitView(
        viewType: 'posecoach/camera-preview',
        creationParamsCodec: StandardMessageCodec(),
      ),
      TargetPlatform.android => const AndroidView(
        viewType: 'posecoach/camera-preview',
        creationParamsCodec: StandardMessageCodec(),
      ),
      _ => const Center(
        child: Text('Camera preview is supported on iOS and Android.'),
      ),
    };
  }
}
