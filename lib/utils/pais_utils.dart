const Map<String, String> siglasPorPais = {
  'ESPECIAIS': 'FWC',
  'MÉXICO': 'MEX',
  'ÁFRICA DO SUL': 'RSA',
  'REPÚBLICA DA COREIA': 'KOR',
  'REPÚBLICA TCHECA': 'CZE',
  'CANADÁ': 'CAN',
  'BÓSNIA E HERZEGOVINA': 'BIH',
  'CATAR': 'QAT',
  'SUÍÇA': 'SUI',
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
  'PAÍSES BAIXOS': 'NED',
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
  'USBEQUISTÃO': 'UZB',
  'COLÔMBIA': 'COL',
  'INGLATERRA': 'ENG',
  'CROÁCIA': 'CRO',
  'GANA': 'GHA',
  'PANAMÁ': 'PAN',
  'COCA-COLA': 'CC',
};

const Map<String, int> ordemPorPais = {
  'ESPECIAIS': 0,
  'MÉXICO': 1,
  'ÁFRICA DO SUL': 2,
  'REPÚBLICA DA COREIA': 4,
  'REPÚBLICA TCHECA': 5,
  'CANADÁ': 6,
  'BÓSNIA E HERZEGOVINA': 7,
  'CATAR': 8,
  'SUÍÇA': 9,
  'BRASIL': 10,
  'MARROCOS': 11,
  'HAITI': 12,
  'ESCÓCIA': 13,
  'ESTADOS UNIDOS': 14,
  'PARAGUAI': 15,
  'AUSTRÁLIA': 16,
  'TURQUIA': 17,
  'ALEMANHA': 18,
  'CURAÇAO': 18,
  'COSTA DO MARFIM': 19,
  'EQUADOR': 20,
  'PAÍSES BAIXOS': 21,
  'JAPÃO': 22,
  'SUÉCIA': 23,
  'TUNÍSIA': 24,
  'BÉLGICA': 25,
  'EGITO': 26,
  'IRÃ': 27,
  'NOVA ZELÂNDIA': 28,
  'ESPANHA': 29,
  'CABO VERDE': 30,
  'ARÁBIA SAUDITA': 31,
  'URUGUAI': 32,
  'FRANÇA': 33,
  'SENEGAL': 34,
  'IRAQUE': 35,
  'NORUEGA': 36,
  'ARGENTINA': 37,
  'ARGÉLIA': 38,
  'ÁUSTRIA': 39,
  'JORDÂNIA': 40,
  'PORTUGAL': 41,
  'REPÚBLICA DEMOCRÁTICA DO CONGO': 42,
  'USBEQUISTÃO': 43,
  'COLÔMBIA': 44,
  'INGLATERRA': 45,
  'CROÁCIA': 46,
  'GANA': 47,
  'PANAMÁ': 48,
  'COCA-COLA': 49,
};

const Map<String, String> nomesInglesParaNomeApp = {
  'SPECIALS': 'ESPECIAIS',
  'FWC': 'ESPECIAIS',

  'MEXICO': 'MÉXICO',
  'SOUTH AFRICA': 'ÁFRICA DO SUL',

  'KOREA REPUBLIC': 'REPÚBLICA DA COREIA',
  'REPUBLIC OF KOREA': 'REPÚBLICA DA COREIA',
  'SOUTH KOREA': 'REPÚBLICA DA COREIA',

  'CZECH REPUBLIC': 'REPÚBLICA TCHECA',
  'CZECHIA': 'REPÚBLICA TCHECA',

  'CANADA': 'CANADÁ',

  'BOSNIA AND HERZEGOVINA': 'BÓSNIA E HERZEGOVINA',
  'BOSNIA HERZEGOVINA': 'BÓSNIA E HERZEGOVINA',
  'BOSNIA': 'BÓSNIA E HERZEGOVINA',

  'QATAR': 'CATAR',
  'SWITZERLAND': 'SUÍÇA',
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
  'TURKIYE': 'TURQUIA',

  'GERMANY': 'ALEMANHA',

  'CURACAO': 'CURAÇAO',
  'CURAÇAO': 'CURAÇAO',

  'COTE D IVOIRE': 'COSTA DO MARFIM',
  'CÔTE D IVOIRE': 'COSTA DO MARFIM',
  'COTE DIVOIRE': 'COSTA DO MARFIM',
  'IVORY COAST': 'COSTA DO MARFIM',

  'ECUADOR': 'EQUADOR',

  'NETHERLANDS': 'PAÍSES BAIXOS',
  'HOLLAND': 'PAÍSES BAIXOS',

  'JAPAN': 'JAPÃO',
  'SWEDEN': 'SUÉCIA',
  'TUNISIA': 'TUNÍSIA',
  'BELGIUM': 'BÉLGICA',
  'EGYPT': 'EGITO',

  'IRAN': 'IRÃ',
  'IRAN IR': 'IRÃ',
  'IR IRAN': 'IRÃ',

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
  'RD CONGO': 'REPÚBLICA DEMOCRÁTICA DO CONGO',

  'UZBEKISTAN': 'USBEQUISTÃO',
  'UZBEQUISTAO': 'USBEQUISTÃO',

  'COLOMBIA': 'COLÔMBIA',
  'ENGLAND': 'INGLATERRA',
  'CROATIA': 'CROÁCIA',

  'GHANA': 'GANA',
  'GANA': 'GANA',

  'PANAMA': 'PANAMÁ',

  'COCA COLA': 'COCA-COLA',
  'COCA-COLA': 'COCA-COLA',
  'COCACOLA': 'COCA-COLA',
  'CC': 'COCA-COLA',
};

String? bandeiraAssetPais(String nome) {
  final nomeNormalizado = nome.trim().toUpperCase();

  if (nomeNormalizado == 'ESPECIAIS') {
    return 'assets/flags/fwc.png';
  }

  if (nomeNormalizado == 'COCA-COLA') {
    return 'assets/flags/cc.png';
  }

  final sigla = siglasPorPais[nomeNormalizado];

  if (sigla == null) return null;

  return 'assets/flags/${sigla.toLowerCase()}.png';
}

String? prefixoPorNomeDetectadoNoAlbum(String textoDetectado) {
  final textoNormalizado = normalizarTextoPais(textoDetectado);

  final apelidosFortes = <String, String>{
    'SPECIALS': 'ESPECIAIS',
    'FWC': 'ESPECIAIS',

    'MEXICO': 'MÉXICO',
    'MEXIC0': 'MÉXICO',
    'MEX1CO': 'MÉXICO',
    'MEXLCO': 'MÉXICO',
    'MEXICANA': 'MÉXICO',
    'WE ARE MEXICO': 'MÉXICO',

    'SOUTH AFRICA': 'ÁFRICA DO SUL',
    'S0UTH AFRICA': 'ÁFRICA DO SUL',
    'SOUTH AFR1CA': 'ÁFRICA DO SUL',

    'REPUBLIC OF KOREA': 'REPÚBLICA DA COREIA',
    'KOREA REPUBLIC': 'REPÚBLICA DA COREIA',
    'SOUTH KOREA': 'REPÚBLICA DA COREIA',

    'CZECH REPUBLIC': 'REPÚBLICA TCHECA',
    'CZECHIA': 'REPÚBLICA TCHECA',

    'CANADA': 'CANADÁ',

    'BOSNIA AND HERZEGOVINA': 'BÓSNIA E HERZEGOVINA',
    'BOSNIA HERZEGOVINA': 'BÓSNIA E HERZEGOVINA',
    'BOSNIA': 'BÓSNIA E HERZEGOVINA',

    'QATAR': 'CATAR',
    'SWITZERLAND': 'SUÍÇA',
    'BRAZIL': 'BRASIL',
    'MOROCCO': 'MARROCOS',
    'HAITI': 'HAITI',
    'SCOTLAND': 'ESCÓCIA',

    'UNITED STATES OF AMERICA': 'ESTADOS UNIDOS',
    'UNITED STATES': 'ESTADOS UNIDOS',
    'USA': 'ESTADOS UNIDOS',

    'PARAGUAY': 'PARAGUAI',
    'AUSTRALIA': 'AUSTRÁLIA',

    'TURKEY': 'TURQUIA',
    'TÜRKIYE': 'TURQUIA',
    'TURKIYE': 'TURQUIA',

    'GERMANY': 'ALEMANHA',

    'CURACAO': 'CURAÇAO',
    'CURAÇAO': 'CURAÇAO',

    'COTE D IVOIRE': 'COSTA DO MARFIM',
    'CÔTE D IVOIRE': 'COSTA DO MARFIM',
    'COTE DIVOIRE': 'COSTA DO MARFIM',
    'IVORY COAST': 'COSTA DO MARFIM',

    'ECUADOR': 'EQUADOR',
    'NETHERLANDS': 'PAÍSES BAIXOS',
    'HOLLAND': 'PAÍSES BAIXOS',

    'JAPAN': 'JAPÃO',
    'SWEDEN': 'SUÉCIA',
    'TUNISIA': 'TUNÍSIA',
    'BELGIUM': 'BÉLGICA',
    'EGYPT': 'EGITO',

    'IRAN': 'IRÃ',
    'IRAN IR': 'IRÃ',
    'IR IRAN': 'IRÃ',

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
    'RD CONGO': 'REPÚBLICA DEMOCRÁTICA DO CONGO',

    'UZBEKISTAN': 'USBEQUISTÃO',
    'UZBEQUISTAO': 'USBEQUISTÃO',

    'COLOMBIA': 'COLÔMBIA',
    'ENGLAND': 'INGLATERRA',
    'CROATIA': 'CROÁCIA',

    'GHANA': 'GANA',
    'GANA': 'GANA',

    'PANAMA': 'PANAMÁ',

    'COCA COLA': 'COCA-COLA',
    'COCA-COLA': 'COCA-COLA',
    'COCACOLA': 'COCA-COLA',
    'CC': 'COCA-COLA',
  };

  for (final entrada in apelidosFortes.entries) {
    final aliasNormalizado = normalizarTextoPais(entrada.key);

    if (_textoContemTermoFlexivel(textoNormalizado, aliasNormalizado)) {
      return nomeReduzidoPais(entrada.value);
    }
  }

  final nomesOrdenados = nomesInglesParaNomeApp.entries.toList()
    ..sort((a, b) {
      final aNormalizado = normalizarTextoPais(a.key);
      final bNormalizado = normalizarTextoPais(b.key);
      return bNormalizado.length.compareTo(aNormalizado.length);
    });

  for (final entrada in nomesOrdenados) {
    final nomeInglesNormalizado = normalizarTextoPais(entrada.key);

    if (_nomeCurtoAmbiguo(nomeInglesNormalizado)) {
      continue;
    }

    if (_textoContemTermoFlexivel(textoNormalizado, nomeInglesNormalizado)) {
      return nomeReduzidoPais(entrada.value);
    }
  }

  return null;
}

bool _textoContemTermoFlexivel(String textoNormalizado, String termoNormalizado) {
  if (termoNormalizado.isEmpty) return false;

  final textoComEspacos = ' $textoNormalizado ';
  final termoComEspacos = ' $termoNormalizado ';

  if (textoComEspacos.contains(termoComEspacos)) {
    return true;
  }

  final textoSemEspacos = textoNormalizado.replaceAll(' ', '');
  final termoSemEspacos = termoNormalizado.replaceAll(' ', '');

  if (termoSemEspacos.length >= 5 && textoSemEspacos.contains(termoSemEspacos)) {
    return true;
  }

  return false;
}

bool _nomeCurtoAmbiguo(String nomeNormalizado) {
  const nomesAmbiguos = {
    'IRAN',
    'IRAQ',
    'USA',
    'QATAR',
    'HAITI',
    'GHANA',
  };

  return nomesAmbiguos.contains(nomeNormalizado);
}

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
    'ESPECIAIS': '🏆',
    'FWC': '🏆',

    'COCA-COLA': '🥤',
    'COCA COLA': '🥤',
    'CC': '🥤',

    'MÉXICO': '🇲🇽',
    'ÁFRICA DO SUL': '🇿🇦',

    'REPÚBLICA DA COREIA': '🇰🇷',
    'REPÚBLICA DA CORÉIA': '🇰🇷',
    'COREIA DO SUL': '🇰🇷',

    'REPÚBLICA TCHECA': '🇨🇿',
    'CANADÁ': '🇨🇦',

    'BÓSNIA E HERZEGOVINA': '🇧🇦',
    'BOSNIA E HERZEGOVINA': '🇧🇦',

    'CATAR': '🇶🇦',

    'SUÍÇA': '🇨🇭',
    'SUIÇA': '🇨🇭',

    'BRASIL': '🇧🇷',
    'MARROCOS': '🇲🇦',
    'HAITI': '🇭🇹',
    'ESCÓCIA': '🏴󠁧󠁢󠁳󠁣󠁴󠁿',
    'ESTADOS UNIDOS': '🇺🇸',
    'PARAGUAI': '🇵🇾',
    'AUSTRÁLIA': '🇦🇺',
    'TURQUIA': '🇹🇷',
    'ALEMANHA': '🇩🇪',
    'CURAÇAO': '🇨🇼',
    'COSTA DO MARFIM': '🇨🇮',
    'EQUADOR': '🇪🇨',

    'PAÍSES BAIXOS': '🇳🇱',
    'HOLANDA': '🇳🇱',

    'JAPÃO': '🇯🇵',
    'SUÉCIA': '🇸🇪',
    'TUNÍSIA': '🇹🇳',
    'BÉLGICA': '🇧🇪',
    'EGITO': '🇪🇬',
    'IRÃ': '🇮🇷',
    'NOVA ZELÂNDIA': '🇳🇿',
    'ESPANHA': '🇪🇸',
    'CABO VERDE': '🇨🇻',
    'ARÁBIA SAUDITA': '🇸🇦',
    'URUGUAI': '🇺🇾',
    'FRANÇA': '🇫🇷',
    'SENEGAL': '🇸🇳',
    'IRAQUE': '🇮🇶',
    'NORUEGA': '🇳🇴',
    'ARGENTINA': '🇦🇷',
    'ARGÉLIA': '🇩🇿',
    'ÁUSTRIA': '🇦🇹',
    'JORDÂNIA': '🇯🇴',
    'PORTUGAL': '🇵🇹',
    'REPÚBLICA DEMOCRÁTICA DO CONGO': '🇨🇩',

    'USBEQUISTÃO': '🇺🇿',
    'UZBEQUISTÃO': '🇺🇿',

    'COLÔMBIA': '🇨🇴',
    'INGLATERRA': '🏴',
    'CROÁCIA': '🇭🇷',

    'GANA': '🇬🇭',
    'GHANA': '🇬🇭',

    'PANAMÁ': '🇵🇦',
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