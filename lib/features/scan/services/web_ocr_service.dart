import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

@JS('reconhecerTextoImagem')
external JSPromise<JSString> _reconhecerTextoImagem(JSString base64Image);

class WebOcrService {
  Future<String> reconhecerTexto(Uint8List imagemBytes) async {
    final base64Image = 'data:image/jpeg;base64,${base64Encode(imagemBytes)}';

    final resultado = await _reconhecerTextoImagem(
      base64Image.toJS,
    ).toDart;

    return resultado.toDart;
  }

  void dispose() {}
}