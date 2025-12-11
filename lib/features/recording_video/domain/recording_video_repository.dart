import 'package:camera/camera.dart';

abstract class RecordingVideoRepository {
  Future<void> init();
  Future<void> startRecording();
  Future<String> stopRecording();
  bool get isInitialized;
  CameraController get controller;
}
