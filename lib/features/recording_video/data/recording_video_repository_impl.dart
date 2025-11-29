import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:lingo_sign/features/recording_video/data/video_service.dart';
import 'package:lingo_sign/features/recording_video/domain/recording_video_repository.dart';

class RecordingVideoRepositoryImpl extends RecordingVideoRepository {
  late final VideoService service;
  bool _initialized = false;

  RecordingVideoRepositoryImpl(this.service);

  @override
  Future<void> init() async {
    await service.init();
    _initialized = true;
  }

  @override
  Future<void> startRecording() async {
    await service.startRecording();
  }

  @override
  Future<String> stopRecording() async {
    final video = await service.stopRecording();

    if (video != null) {
      final path = video.path;
      return path;
    }
    return '';
  }


  @override
  bool get isInitialized => _initialized;

  @override
  CameraController get controller => service.controller;
}
