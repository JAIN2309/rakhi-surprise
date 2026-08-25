import 'dart:typed_data';

/// Stub — no-op on non-web platforms.
Future<void> downloadPngBytes(Uint8List bytes, String filename) async {
  // Download is only supported on web.
}
