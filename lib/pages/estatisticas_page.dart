import 'package:flutter/material.dart';

import '../models/figurinha.dart';
import '../widgets/progresso_selecao_story_item.dart';

class EstatisticasPage extends StatelessWidget {
  final List<Figurinha> figurinhas;

  const EstatisticasPage({
    super.key,
    required this.figurinhas,
  });

  int get totalTenho {
    return figurinhas.where((figurinha) => figurinha.tenho).length;
  }

  int get totalFaltando {
    return figurinhas.length - totalTenho;
  }

  int get totalRepetidas {
    return figurinhas.fold(
      0,
      (total, figurinha) => total + figurinha.repetidas,
    );
  }

  double get progressoGeral {
    if (figurinhas.isEmpty) return 0;
    return totalTenho / figurinhas.length;
  }

  String get porcentagemGeral {
    return (progressoGeral * 100).toStringAsFixed(0);
  }

  List<String> get selecoesDisponiveis {
    final Map<String, int> ordemPorPais = {};

    for (final figurinha in figurinhas) {
      final pais = figurinha.pais;
      final ordem = figurinha.ordemPais;

      if (!ordemPorPais.containsKey(pais)) {
        ordemPorPais[pais] = ordem;
      } else if (ordem < ordemPorPais[pais]!) {
        ordemPorPais[pais] = ordem;
      }
    }

    final selecoes = ordemPorPais.keys.toList();

    selecoes.sort((a, b) {
      final ordemA = ordemPorPais[a] ?? 9999;
      final ordemB = ordemPorPais[b] ?? 9999;

      return ordemA.compareTo(ordemB);
    });

    return selecoes;
  }

  int totalPorSelecao(String selecao) {
    return figurinhas.where((figurinha) => figurinha.pais == selecao).length;
  }

  int totalTenhoPorSelecao(String selecao) {
    return figurinhas.where((figurinha) {
      return figurinha.pais == selecao && figurinha.tenho;
    }).length;
  }

  int totalFaltandoPorSelecao(String selecao) {
    return totalPorSelecao(selecao) - totalTenhoPorSelecao(selecao);
  }

  Figurinha? get figurinhaMaisRepetida {
    final repetidas = figurinhas.where((figurinha) {
      return figurinha.repetidas > 0;
    }).toList();

    if (repetidas.isEmpty) return null;

    repetidas.sort((a, b) {
      return b.repetidas.compareTo(a.repetidas);
    });

    return repetidas.first;
  }

  String get selecaoMaisCompleta {
    if (selecoesDisponiveis.isEmpty) return '-';

    final selecoes = [...selecoesDisponiveis];

    selecoes.sort((a, b) {
      final totalA = totalPorSelecao(a);
      final totalB = totalPorSelecao(b);

      final progressoA = totalA == 0 ? 0.0 : totalTenhoPorSelecao(a) / totalA;
      final progressoB = totalB == 0 ? 0.0 : totalTenhoPorSelecao(b) / totalB;

      return progressoB.compareTo(progressoA);
    });

    return selecoes.first;
  }

  String get selecaoComMaisFaltantes {
    if (selecoesDisponiveis.isEmpty) return '-';

    final selecoes = [...selecoesDisponiveis];

    selecoes.sort((a, b) {
      return totalFaltandoPorSelecao(b).compareTo(
        totalFaltandoPorSelecao(a),
      );
    });

    return selecoes.first;
  }

  @override
  Widget build(BuildContext context) {
    final maisRepetida = figurinhaMaisRepetida;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Resumo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2.3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _ResumoCard(
              icone: Icons.donut_large,
              titulo: 'Completado',
              valor: '$porcentagemGeral%',
            ),
            _ResumoCard(
              icone: Icons.collections_bookmark,
              titulo: 'Total',
              valor: figurinhas.length.toString(),
            ),
            _ResumoCard(
              icone: Icons.remove_circle_outline,
              titulo: 'Me faltam',
              valor: totalFaltando.toString(),
            ),
            _ResumoCard(
              icone: Icons.check_circle_outline,
              titulo: 'Tenho',
              valor: totalTenho.toString(),
            ),
            _ResumoCard(
              icone: Icons.repeat,
              titulo: 'Repetidas',
              valor: totalRepetidas.toString(),
            ),
            _ResumoCard(
              icone: Icons.flag_circle_outlined,
              titulo: 'Seleções',
              valor: selecoesDisponiveis.length.toString(),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Progresso geral',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$totalTenho/${figurinhas.length} figurinhas',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progressoGeral,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(20),
                ),
                const SizedBox(height: 8),
                Text('$porcentagemGeral% completo'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Progresso por seleção',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 108,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: selecoesDisponiveis.length,
            itemBuilder: (context, index) {
              final selecao = selecoesDisponiveis[index];
              final total = totalPorSelecao(selecao);
              final tenho = totalTenhoPorSelecao(selecao);

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ProgressoSelecaoStoryItem(
                  nome: selecao,
                  total: total,
                  tenho: tenho,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Destaques',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        _DestaqueItem(
          icone: Icons.emoji_events,
          titulo: 'Mais repetida',
          valor: maisRepetida == null
              ? '-'
              : '${maisRepetida.numeroAlbum} x${maisRepetida.repetidas}',
        ),
        _DestaqueItem(
          icone: Icons.star,
          titulo: 'Mais completa',
          valor: selecaoMaisCompleta,
        ),
        _DestaqueItem(
          icone: Icons.warning_amber,
          titulo: 'Mais faltantes',
          valor: selecaoComMaisFaltantes,
        ),
      ],
    );
  }
}

class _ResumoCard extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _ResumoCard({
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              child: Icon(icone),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    valor,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestaqueItem extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _DestaqueItem({
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icone),
        ),
        title: Text(titulo),
        trailing: Text(
          valor,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}