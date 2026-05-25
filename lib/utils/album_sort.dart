import '../models/figurinha.dart';

int compararNumeroAlbum(String a, String b) {
  final regex = RegExp(r'^([A-Za-zÀ-ÿ]+)(\d+)(.*)$');

  final matchA = regex.firstMatch(a);
  final matchB = regex.firstMatch(b);

  if (matchA == null || matchB == null) {
    return a.compareTo(b);
  }

  final prefixoA = matchA.group(1)!.toUpperCase();
  final prefixoB = matchB.group(1)!.toUpperCase();

  final comparacaoPrefixo = prefixoA.compareTo(prefixoB);

  if (comparacaoPrefixo != 0) {
    return comparacaoPrefixo;
  }

  final numeroA = int.tryParse(matchA.group(2)!) ?? 0;
  final numeroB = int.tryParse(matchB.group(2)!) ?? 0;

  final comparacaoNumero = numeroA.compareTo(numeroB);

  if (comparacaoNumero != 0) {
    return comparacaoNumero;
  }

  final sufixoA = matchA.group(3) ?? '';
  final sufixoB = matchB.group(3) ?? '';

  return sufixoA.compareTo(sufixoB);
}

int compararFigurinhasAlbum(Figurinha a, Figurinha b) {
  final comparacaoPais = a.ordemPais.compareTo(b.ordemPais);

  if (comparacaoPais != 0) {
    return comparacaoPais;
  }

  return compararNumeroAlbum(a.numeroAlbum, b.numeroAlbum);
}