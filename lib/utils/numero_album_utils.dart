String prefixoNumeroAlbum(String valor) {
  final texto = valor.trim();

  final match = RegExp(r'^([A-Za-zÀ-ÿ]+)').firstMatch(texto);

  if (match == null) return texto.toUpperCase();

  return match.group(1)!.toUpperCase();
}

String numeroVisualAlbum(String valor) {
  final texto = valor.trim();

  final match = RegExp(r'(\d+)').firstMatch(texto);

  if (match == null) return texto;

  return match.group(1)!;
}