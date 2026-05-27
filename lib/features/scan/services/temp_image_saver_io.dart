import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

Future<String?> salvarImagemTemporaria(
  Uint8List bytes, {
  String prefixo = 'scan',
}) async {
  final diretorio = await getTemporaryDirectory();

  final arquivo = File(
    '${diretorio.path}/${prefixo}_${DateTime.now().millisecondsSinceEpoch}.jpg',
  );

  await arquivo.writeAsBytes(bytes, flush: true);

  return arquivo.path;
}