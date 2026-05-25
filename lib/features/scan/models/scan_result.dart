class ScanResult {
  final List<String> codigosDetectados;
  final String textoExtraido;

  ScanResult({
    required this.codigosDetectados,
    required this.textoExtraido,
  });

  factory ScanResult.vazio() {
    return ScanResult(
      codigosDetectados: [],
      textoExtraido: '',
    );
  }
}