import 'dart:ui';

abstract interface class PoseCoordinateTransformer {
  Offset normalizedToPreview(
    Offset normalized,
    Size previewSize, {
    bool mirrored = false,
  });
  Offset modelToPreview(
    Offset modelPoint,
    Size modelSize,
    Size previewSize, {
    bool mirrored = false,
  });
}

class LetterboxedCoordinateTransformer implements PoseCoordinateTransformer {
  const LetterboxedCoordinateTransformer();

  @override
  Offset normalizedToPreview(
    Offset normalized,
    Size previewSize, {
    bool mirrored = false,
  }) {
    final x = mirrored ? 1 - normalized.dx : normalized.dx;
    return Offset(x * previewSize.width, normalized.dy * previewSize.height);
  }

  @override
  Offset modelToPreview(
    Offset modelPoint,
    Size modelSize,
    Size previewSize, {
    bool mirrored = false,
  }) => normalizedToPreview(
    Offset(modelPoint.dx / modelSize.width, modelPoint.dy / modelSize.height),
    previewSize,
    mirrored: mirrored,
  );
}
