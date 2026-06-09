import 'dart:io';

class PitchValidationError implements Exception {
  PitchValidationError(this.message);
  final String message;
  @override
  String toString() => message;
}

class PitchValidator {
  PitchValidator._();

  static const int maxBytes = 50 * 1024 * 1024; // 50 MB — mirrors storage cap
  static const Duration maxDuration = Duration(seconds: 60);
  static const Set<String> allowedExtensions = {'mp4', 'mov', 'm4v', 'webm'};

  /// Throws [PitchValidationError] when the file is not acceptable.
  /// Duration check is the caller's responsibility (needs VideoPlayer).
  static Future<void> validateFile(File file) async {
    final ext = file.path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(ext)) {
      throw PitchValidationError(
        'Unsupported format. Use mp4, mov, m4v, or webm.',
      );
    }
    final bytes = await file.length();
    if (bytes > maxBytes) {
      throw PitchValidationError(
        'Video is too large. Keep it under 50 MB.',
      );
    }
  }

  static void validateDuration(Duration d) {
    if (d > maxDuration + const Duration(milliseconds: 750)) {
      throw PitchValidationError(
        'Pitches must be 60 seconds or shorter.',
      );
    }
  }
}
