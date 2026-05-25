import '../models/scan_result.dart';
import '../../../utils/pais_utils.dart';

class AlbumScanService {
  Future<ScanResult> processarTextoManual(String texto) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return processarTextoExtraido(texto);
  }

  ScanResult processarTextoExtraido(String texto) {
    final codigos = _detectarCodigos(texto);

    return ScanResult(
      codigosDetectados: codigos,
      textoExtraido: texto,
    );
  }

  String? detectarPrefixoDoTexto(String texto) {
    final prefixoPorNome = prefixoPorNomeDetectadoNoAlbum(texto);

    if (prefixoPorNome != null) {
      return prefixoPorNome;
    }

    final prefixoPorCodigo = _detectarPrefixoPorCodigoVisivel(texto);

    if (prefixoPorCodigo != null) {
      return prefixoPorCodigo;
    }

    return null;
  }

  List<String> gerarCodigosPorPrefixo({
    required String prefixo,
    int inicio = 1,
    int fim = 20,
  }) {
    return List.generate(
      fim - inicio + 1,
      (index) => '${prefixo.toUpperCase()}${inicio + index}',
    );
  }

  String? _detectarPrefixoPorCodigoVisivel(String texto) {
    final codigos = _detectarCodigos(texto);

    if (codigos.isEmpty) return null;

    final contagem = <String, int>{};

    for (final codigo in codigos) {
      final match = RegExp(r'^([A-Z]{2,4})\d{1,3}$').firstMatch(codigo);

      if (match == null) continue;

      final prefixo = match.group(1)!;
      contagem[prefixo] = (contagem[prefixo] ?? 0) + 1;
    }

    if (contagem.isEmpty) return null;

    final entradasOrdenadas = contagem.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return entradasOrdenadas.first.key;
  }

  List<String> _detectarCodigos(String texto) {
    final regex = RegExp(
      r'\b[A-Z]{2,4}\s*-?\s*\d{1,3}\b',
      caseSensitive: false,
    );

    final codigos = regex
        .allMatches(texto)
        .map((match) {
          return match
              .group(0)!
              .replaceAll(' ', '')
              .replaceAll('-', '')
              .toUpperCase();
        })
        .where(_pareceCodigoDeFigurinha)
        .toSet()
        .toList();

    codigos.sort(_compararCodigos);

    return codigos;
  }

  bool _pareceCodigoDeFigurinha(String codigo) {
    final regexValido = RegExp(r'^([A-Z]{2,4})(\d{1,3})$');
    final match = regexValido.firstMatch(codigo);

    if (match == null) {
      return false;
    }

    final prefixo = match.group(1)!;
    final numero = int.tryParse(match.group(2)!);

    if (numero == null || numero <= 0) {
      return false;
    }

    final prefixosValidos = siglasPorPais.values.toSet();

    if (!prefixosValidos.contains(prefixo)) {
      return false;
    }

    final ignorados = {
      'FIFA26',
      'CUP26',
      'WORLD26',
    };

    return !ignorados.contains(codigo);
  }

  int _compararCodigos(String a, String b) {
    final regex = RegExp(r'^([A-Z]+)(\d+)$');

    final matchA = regex.firstMatch(a);
    final matchB = regex.firstMatch(b);

    if (matchA == null || matchB == null) {
      return a.compareTo(b);
    }

    final prefixoA = matchA.group(1)!;
    final prefixoB = matchB.group(1)!;

    final comparacaoPrefixo = prefixoA.compareTo(prefixoB);

    if (comparacaoPrefixo != 0) {
      return comparacaoPrefixo;
    }

    final numeroA = int.parse(matchA.group(2)!);
    final numeroB = int.parse(matchB.group(2)!);

    return numeroA.compareTo(numeroB);
  }

  void dispose() {}
}