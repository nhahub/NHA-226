import 'package:camera/camera.dart';

class VideoService {
  late CameraController controller;
  static late List<CameraDescription> cameras;

  Future<void> init() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[1], ResolutionPreset.high);
    await controller.initialize();
  }

  Future<void> startRecording() async {
    await controller.startVideoRecording();
  }

  Future<XFile> stopRecording() async {
    return await controller.stopVideoRecording();
  }
}
