import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationRepositoryImpl {


  Future<String> getTranslation(String path) async {
    final url = Uri.parse(
      "https://khalood619-signbridge-api.hf.space/sign/predict",
    );

    var request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath('file', path));

    var response = await request.send();

    try {
      print(response);
      final body = await response.stream.bytesToString();

      final Map<String, dynamic> data = jsonDecode(body);

      final text = data["gloss"];

      return text;
    } catch (e) {
      print("Error: ${response.statusCode}");
      return "";
    }
  }

  
}
