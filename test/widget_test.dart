import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posecoach/app/app.dart';

void main() {
  testWidgets('shows the pose library on startup', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PoseCoachApp()));
    expect(find.text('Choose your pose'), findsOneWidget);
    expect(find.text('The Welcome'), findsOneWidget);
  });

  testWidgets('opens camera screen from a pose card', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PoseCoachApp()));
    await tester.tap(find.text('The Welcome'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
  });
}
