abstract interface class PersonSegmentationEngine {
  Future<String?> createTransparentCutout(String imagePath);
}
