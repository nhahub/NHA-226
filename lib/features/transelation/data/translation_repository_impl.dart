import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TranslationRepositoryImpl {
  Future<String> getTranslation(String path) async {
    final url = Uri.parse(
      "https://khalood619-signbridge-api.hf.space/sign/predict",
    );

    var request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath('video', path));

    var response = await request.send();
    try {
      final body = await response.stream.bytesToString();

      final Map<String, dynamic> data = jsonDecode(body);

      final text = data["gloss"];

      return text;
    } catch (e) {
      print("Error: ${response.statusCode}");
      return "";
    }
  }

  Future<String> uploadVideo() async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      return video.path;
    } else {
      return "";
    }
  }
}
