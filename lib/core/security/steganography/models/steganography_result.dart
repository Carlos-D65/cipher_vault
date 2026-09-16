class SteganographyResult {
  final List<int> imageBytes;
  final String format;

  const SteganographyResult({
    required this.imageBytes,
    required this.format,
  });
}