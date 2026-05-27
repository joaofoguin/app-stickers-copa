import 'dart:io';
import 'dart:typed_data';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

class WebOcrService {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  Future<String> reconhecerTexto(
    Uint8List imageBytes, {
    String? imagePath,
  }) async {
    final caminhoImagem = imagePath ?? await _salvarImagemTemporaria(imageBytes);

    final inputImage = InputImage.fromFilePath(caminhoImagem);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    return recognizedText.text;
  }

  Future<String> _salvarImagemTemporaria(Uint8List imageBytes) async {
    final diretorio = await getTemporaryDirectory();
    final arquivo = File(
      '${diretorio.path}/scan_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    await arquivo.writeAsBytes(imageBytes, flush: true);

    return arquivo.path;
  }

  void dispose() {
    _textRecognizer.close();
  }
}