// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

final _videos = <String, html.VideoElement>{};
final _streams = <String, html.MediaStream>{};

void registerCameraView(String viewId, bool frontCamera) {
  final facingMode = frontCamera ? 'user' : 'environment';
  ui_web.platformViewRegistry.registerViewFactory(viewId, (int id) {
    final video = html.VideoElement()
      ..autoplay = true
      ..muted = true
      ..setAttribute('playsinline', 'true')
      ..style.cssText =
          'width:100%;height:100%;object-fit:cover;background:#000;';

    _videos[viewId] = video;

    html.window.navigator.mediaDevices?.getUserMedia({
      'video': {
        'facingMode': facingMode,
        'width': {'ideal': 1280},
        'height': {'ideal': 720},
      },
      'audio': false,
    }).then((stream) {
      _streams[viewId] = stream;
      video.srcObject = stream;
    }).catchError((_) {});

    return video;
  });
}

Future<Uint8List?> captureWebFrame(String viewId) async {
  final video = _videos[viewId];
  if (video == null || video.videoWidth == 0 || video.videoHeight == 0) {
    return null;
  }
  final canvas = html.CanvasElement(
    width: video.videoWidth,
    height: video.videoHeight,
  );
  canvas.context2D.drawImage(video, 0, 0);
  final dataUrl = canvas.toDataUrl('image/jpeg', 0.85);
  return base64Decode(dataUrl.split(',').last);
}

void disposeWebCamera(String viewId) {
  _streams[viewId]?.getTracks().forEach((t) => t.stop());
  _streams.remove(viewId);
  _videos.remove(viewId);
}
