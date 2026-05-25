const Map<String, String> siglasPorPais = {
  'ESPECIAIS': 'FWC',
  'MÉXICO': 'MEX',
  'ÁFRICA DO SUL': 'RSA',
  'REPÚBLICA DA CORÉIA': 'KOR',
  'REPÚBLICA TCHECA': 'CZE',
  'CANADÁ': 'CAN',
  'BOSNIA E HERZEGOVINA': 'BIH',
  'QATAR': 'QAT',
  'SUIÇA': 'SUI',
  'BRASIL': 'BRA',
  'MARROCOS': 'MAR',
  'HAITI': 'HAI',
  'ESCÓCIA': 'SCO',
  'ESTADOS UNIDOS': 'USA',
  'PARAGUAI': 'PAR',
  'AUSTRÁLIA': 'AUS',
  'TURQUIA': 'TUR',
  'ALEMANHA': 'GER',
  'CURAÇAO': 'CUW',
  'COSTA DO MARFIM': 'CIV',
  'EQUADOR': 'ECU',
  'HOLANDA': 'NED',
  'JAPÃO': 'JPN',
  'SUÉCIA': 'SWE',
  'TUNÍSIA': 'TUN',
  'BÉLGICA': 'BEL',
  'EGITO': 'EGY',
  'IRÃ': 'IRN',
  'NOVA ZELÂNDIA': 'NZL',
  'ESPANHA': 'ESP',
  'CABO VERDE': 'CPV',
  'ARÁBIA SAUDITA': 'KSA',
  'URUGUAI': 'URU',
  'FRANÇA': 'FRA',
  'SENEGAL': 'SEN',
  'IRAQUE': 'IRQ',
  'NORUEGA': 'NOR',
  'ARGENTINA': 'ARG',
  'ARGÉLIA': 'ALG',
  'ÁUSTRIA': 'AUT',
  'JORDÂNIA': 'JOR',
  'PORTUGAL': 'POR',
  'REPÚBLICA DEMOCRÁTICA DO CONGO': 'COD',
  'UZBEQUISTÃO': 'UZB',
  'COLÔMBIA': 'COL',
  'INGLATERRA': 'ENG',
  'CROÁCIA': 'CRO',
  'GHANA': 'GHA',
  'PANAMÁ': 'PAN',
  'COCA-COLA': 'CC',
};

const Map<String, String> nomesInglesParaNomeApp = {
  'SPECIALS': 'ESPECIAIS',
  'MEXICO': 'MÉXICO',
  'SOUTH AFRICA': 'ÁFRICA DO SUL',
  'KOREA REPUBLIC': 'REPÚBLICA DA CORÉIA',
  'REPUBLIC OF KOREA': 'REPÚBLICA DA CORÉIA',
  'CZECH REPUBLIC': 'REPÚBLICA TCHECA',
  'CANADA': 'CANADÁ',
  'BOSNIA AND HERZEGOVINA': 'BOSNIA E HERZEGOVINA',
  'QATAR': 'QATAR',
  'SWITZERLAND': 'SUIÇA',
  'BRAZIL': 'BRASIL',
  'MOROCCO': 'MARROCOS',
  'HAITI': 'HAITI',
  'SCOTLAND': 'ESCÓCIA',
  'UNITED STATES': 'ESTADOS UNIDOS',
  'UNITED STATES OF AMERICA': 'ESTADOS UNIDOS',
  'USA': 'ESTADOS UNIDOS',
  'PARAGUAY': 'PARAGUAI',
  'AUSTRALIA': 'AUSTRÁLIA',
  'TURKEY': 'TURQUIA',
  'TÜRKIYE': 'TURQUIA',
  'GERMANY': 'ALEMANHA',
  'CURACAO': 'CURAÇAO',
  'CURAÇAO': 'CURAÇAO',
  'COTE D IVOIRE': 'COSTA DO MARFIM',
  'CÔTE D IVOIRE': 'COSTA DO MARFIM',
  'IVORY COAST': 'COSTA DO MARFIM',
  'ECUADOR': 'EQUADOR',
  'NETHERLANDS': 'HOLANDA',
  'JAPAN': 'JAPÃO',
  'SWEDEN': 'SUÉCIA',
  'TUNISIA': 'TUNÍSIA',
  'BELGIUM': 'BÉLGICA',
  'EGYPT': 'EGITO',
  'IRAN': 'IRÃ',
  'IRAN IR': 'IRÃ',
  'NEW ZEALAND': 'NOVA ZELÂNDIA',
  'SPAIN': 'ESPANHA',
  'CAPE VERDE': 'CABO VERDE',
  'SAUDI ARABIA': 'ARÁBIA SAUDITA',
  'URUGUAY': 'URUGUAI',
  'FRANCE': 'FRANÇA',
  'SENEGAL': 'SENEGAL',
  'IRAQ': 'IRAQUE',
  'NORWAY': 'NORUEGA',
  'ARGENTINA': 'ARGENTINA',
  'ALGERIA': 'ARGÉLIA',
  'AUSTRIA': 'ÁUSTRIA',
  'JORDAN': 'JORDÂNIA',
  'PORTUGAL': 'PORTUGAL',
  'DR CONGO': 'REPÚBLICA DEMOCRÁTICA DO CONGO',
  'CONGO DR': 'REPÚBLICA DEMOCRÁTICA DO CONGO',
  'DEMOCRATIC REPUBLIC OF THE CONGO': 'REPÚBLICA DEMOCRÁTICA DO CONGO',
  'UZBEKISTAN': 'UZBEQUISTÃO',
  'COLOMBIA': 'COLÔMBIA',
  'ENGLAND': 'INGLATERRA',
  'CROATIA': 'CROÁCIA',
  'GHANA': 'GHANA',
  'PANAMA': 'PANAMÁ',
  'COCA COLA': 'COCA-COLA',
  'COCA-COLA': 'COCA-COLA',
};

String normalizarTextoPais(String texto) {
  return texto
      .trim()
      .toUpperCase()
      .replaceAll('-', ' ')
      .replaceAll('.', ' ')
      .replaceAll(',', ' ')
      .replaceAll(':', ' ')
      .replaceAll(';', ' ')
      .replaceAll('Á', 'A')
      .replaceAll('À', 'A')
      .replaceAll('Ã', 'A')
      .replaceAll('Â', 'A')
      .replaceAll('É', 'E')
      .replaceAll('Ê', 'E')
      .replaceAll('Í', 'I')
      .replaceAll('Ó', 'O')
      .replaceAll('Õ', 'O')
      .replaceAll('Ô', 'O')
      .replaceAll('Ú', 'U')
      .replaceAll('Ü', 'U')
      .replaceAll('Ç', 'C')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String bandeiraEmojiPais(String nome) {
  final nomeNormalizado = nome.trim().toUpperCase();

  const bandeiras = {
    'MÉXICO': '🇲🇽',
    'CANADÁ': '🇨🇦',
    'ESTADOS UNIDOS': '🇺🇸',
    'BRASIL': '🇧🇷',
    'ARGENTINA': '🇦🇷',
    'FRANÇA': '🇫🇷',
    'ALEMANHA': '🇩🇪',
    'ESPANHA': '🇪🇸',
    'PORTUGAL': '🇵🇹',
    'INGLATERRA': '🏴',
    'URUGUAI': '🇺🇾',
    'ITÁLIA': '🇮🇹',
    'HOLANDA': '🇳🇱',
    'BÉLGICA': '🇧🇪',
    'CROÁCIA': '🇭🇷',
    'JAPÃO': '🇯🇵',
    'COREIA DO SUL': '🇰🇷',
    'ÁFRICA DO SUL': '🇿🇦',
  };

  return bandeiras[nomeNormalizado] ?? '';
}

String nomeReduzidoPais(String nome) {
  final nomeNormalizado = nome.trim().toUpperCase();

  if (siglasPorPais.containsKey(nomeNormalizado)) {
    return siglasPorPais[nomeNormalizado]!;
  }

  final nomeSemAcento = normalizarTextoPais(nome);

  for (final entrada in siglasPorPais.entries) {
    final chaveNormalizada = normalizarTextoPais(entrada.key);

    if (chaveNormalizada == nomeSemAcento) {
      return entrada.value;
    }
  }

  final partes = nomeNormalizado.split(' ');

  if (partes.length >= 2) {
    return partes
        .where((parte) => parte.isNotEmpty)
        .map((parte) => parte[0])
        .join();
  }

  if (nomeNormalizado.length <= 3) {
    return nomeNormalizado;
  }

  return nomeNormalizado.substring(0, 3);
}

String? prefixoPorNomeDetectadoNoAlbum(String textoDetectado) {
  final textoNormalizado = normalizarTextoPais(textoDetectado);

  for (final entrada in nomesInglesParaNomeApp.entries) {
    final nomeInglesNormalizado = normalizarTextoPais(entrada.key);

    if (textoNormalizado.contains(nomeInglesNormalizado)) {
      final nomeApp = entrada.value;
      return nomeReduzidoPais(nomeApp);
    }
  }

  for (final entrada in siglasPorPais.entries) {
    final nomePortuguesNormalizado = normalizarTextoPais(entrada.key);

    if (textoNormalizado.contains(nomePortuguesNormalizado)) {
      return entrada.value;
    }
  }

  return null;
}