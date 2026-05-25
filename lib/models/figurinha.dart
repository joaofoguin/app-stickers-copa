class Figurinha {
  final int id;
  final String numeroAlbum;
  final String nome;
  final String pais;
  final int ordemPais;

  bool tenho;
  int repetidas;

  Figurinha({
    required this.id,
    required this.numeroAlbum,
    required this.nome,
    required this.pais,
    required this.ordemPais,
    this.tenho = false,
    this.repetidas = 0,
  });

  String get selecao => pais;

  factory Figurinha.fromJson(Map<String, dynamic> json) {
    return Figurinha(
      id: json['id'],
      numeroAlbum: json['numero_album'].toString(),
      nome: json['nome'] ?? '',
      pais: json['pais'] ?? '',
      ordemPais: int.tryParse(
            (json['ordem_pais'] ?? json['ordemPais'] ?? json['ordem'] ?? 9999)
                .toString(),
          ) ??
          9999,
    );
  }
}