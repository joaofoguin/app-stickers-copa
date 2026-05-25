import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/figurinha.dart';

class ColecaoStorage {
  Future<void> carregarDadosSalvos(List<Figurinha> figurinhas) async {
    final db = await AppDatabase.instance.database;

    final registros = await db.query('colecao_usuario');

    final Map<int, Map<String, Object?>> dadosPorId = {
      for (final registro in registros)
        registro['figurinha_id'] as int: registro,
    };

    for (final figurinha in figurinhas) {
      final dados = dadosPorId[figurinha.id];

      if (dados == null) {
        figurinha.tenho = false;
        figurinha.repetidas = 0;
      } else {
        figurinha.tenho = dados['tenho'] == 1;
        figurinha.repetidas = dados['repetidas'] as int? ?? 0;
      }
    }
  }

  Future<void> salvarFigurinha(Figurinha figurinha) async {
    final db = await AppDatabase.instance.database;

    await db.insert(
      'colecao_usuario',
      {
        'figurinha_id': figurinha.id,
        'tenho': figurinha.tenho ? 1 : 0,
        'repetidas': figurinha.repetidas,
        'atualizado_em': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> limparAlbum(List<Figurinha> figurinhas) async {
    final db = await AppDatabase.instance.database;

    await db.delete('colecao_usuario');

    for (final figurinha in figurinhas) {
      figurinha.tenho = false;
      figurinha.repetidas = 0;
    }
  }

  Future<void> marcarVariasComoTenho(List<Figurinha> figurinhas) async {
    final db = await AppDatabase.instance.database;

    final batch = db.batch();

    for (final figurinha in figurinhas) {
      figurinha.tenho = true;

      batch.insert(
        'colecao_usuario',
        {
          'figurinha_id': figurinha.id,
          'tenho': 1,
          'repetidas': figurinha.repetidas,
          'atualizado_em': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }
}