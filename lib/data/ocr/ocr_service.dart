import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final _textRecognizer = TextRecognizer();

  Future<String> extractText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final result = await _textRecognizer.processImage(inputImage);
    return result.text;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
