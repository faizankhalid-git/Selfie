import 'package:flutter/material.dart';

import '../features/camera/presentation/camera_screen.dart';
import '../features/pose_library/presentation/pose_library_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../core/config/app_environment.dart';
import 'theme.dart';

class PoseCoachApp extends StatelessWidget {
  const PoseCoachApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'PoseCoach · ${AppConfig.fromDefines().environment.name}',
    debugShowCheckedModeBanner: false,
    theme: buildPoseCoachTheme(),
    initialRoute: '/',
    routes: {
      '/': (_) => const PoseLibraryScreen(),
      '/camera': (_) => const CameraScreen(),
      '/settings': (_) => const SettingsScreen(),
    },
  );
}
