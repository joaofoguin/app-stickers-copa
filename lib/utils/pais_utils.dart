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

String? bandeiraAssetPais(String nome) {
  final nomeNormalizado = nome.trim().toUpperCase();

  const bandeiras = {
    'MÉXICO': '../assets/flags/mex.png',
    'ÁFRICA DO SUL': '../assets/flags/rsa.png',
    'REPÚBLICA DA CORÉIA': '../assets/flags/kor.png',
    'REPÚBLICA TCHECA': '../assets/flags/cze.png',
    'CANADÁ': '../assets/flags/can.png',
    'BOSNIA E HERZEGOVINA': '../assets/flags/bih.png',
    'QATAR': '../assets/flags/qat.png',
    'SUIÇA': '../assets/flags/sui.png',
    'BRASIL': '../assets/flags/bra.png',
  };

  return bandeiras[nomeNormalizado];
}

String? prefixoPorNomeDetectadoNoAlbum(String textoDetectado) {
  final textoNormalizado = normalizarTextoPais(textoDetectado);

  final apelidosFortes = <String, String>{
    'MEXICO': 'MÉXICO',
    'MEXIC0': 'MÉXICO',
    'MEX1CO': 'MÉXICO',
    'MEXLCO': 'MÉXICO',
    'MEXICANA': 'MÉXICO',
    'WE ARE MEXICO': 'MÉXICO',

    'SOUTH AFRICA': 'ÁFRICA DO SUL',
    'S0UTH AFRICA': 'ÁFRICA DO SUL',
    'SOUTH AFR1CA': 'ÁFRICA DO SUL',

    'BRAZIL': 'BRASIL',
    'ARGENTINA': 'ARGENTINA',
    'GERMANY': 'ALEMANHA',
    'FRANCE': 'FRANÇA',
    'ENGLAND': 'INGLATERRA',
    'PORTUGAL': 'PORTUGAL',
    'SPAIN': 'ESPANHA',
    'JAPAN': 'JAPÃO',
    'NETHERLANDS': 'HOLANDA',
    'BELGIUM': 'BÉLGICA',
    'CROATIA': 'CROÁCIA',
    'COLOMBIA': 'COLÔMBIA',
    'URUGUAY': 'URUGUAI',
    'PARAGUAY': 'PARAGUAI',
    'AUSTRALIA': 'AUSTRÁLIA',
    'CANADA': 'CANADÁ',
    'MOROCCO': 'MARROCOS',
    'SENEGAL': 'SENEGAL',
    'TUNISIA': 'TUNÍSIA',
    'ALGERIA': 'ARGÉLIA',
    'AUSTRIA': 'ÁUSTRIA',
    'NORWAY': 'NORUEGA',
    'SWEDEN': 'SUÉCIA',
    'EGYPT': 'EGITO',
    'ECUADOR': 'EQUADOR',
    'PANAMA': 'PANAMÁ',
    'SCOTLAND': 'ESCÓCIA',
    'TURKEY': 'TURQUIA',
    'TÜRKIYE': 'TURQUIA',
    'JORDAN': 'JORDÂNIA',
    'UZBEKISTAN': 'UZBEQUISTÃO',

    'REPUBLIC OF KOREA': 'REPÚBLICA DA CORÉIA',
    'KOREA REPUBLIC': 'REPÚBLICA DA CORÉIA',
    'CZECH REPUBLIC': 'REPÚBLICA TCHECA',
    'BOSNIA AND HERZEGOVINA': 'BOSNIA E HERZEGOVINA',
    'UNITED STATES OF AMERICA': 'ESTADOS UNIDOS',
    'UNITED STATES': 'ESTADOS UNIDOS',
    'COTE D IVOIRE': 'COSTA DO MARFIM',
    'CÔTE D IVOIRE': 'COSTA DO MARFIM',
    'IVORY COAST': 'COSTA DO MARFIM',
    'NEW ZEALAND': 'NOVA ZELÂNDIA',
    'CAPE VERDE': 'CABO VERDE',
    'SAUDI ARABIA': 'ARÁBIA SAUDITA',
    'DR CONGO': 'REPÚBLICA DEMOCRÁTICA DO CONGO',
    'CONGO DR': 'REPÚBLICA DEMOCRÁTICA DO CONGO',
    'DEMOCRATIC REPUBLIC OF THE CONGO': 'REPÚBLICA DEMOCRÁTICA DO CONGO',
    'COCA COLA': 'COCA-COLA',
    'COCA-COLA': 'COCA-COLA',
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