import 'dart:typed_data';

// Stub — non-web platforms
void registerCameraView(String viewId, bool frontCamera) {}
Future<Uint8List?> captureWebFrame(String viewId) async => null;
void disposeWebCamera(String viewId) {}
