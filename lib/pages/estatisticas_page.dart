import 'package:flutter/material.dart';

import '../models/figurinha.dart';
import '../theme/app_colors.dart';
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
    return '${(progressoGeral * 100).toStringAsFixed(0)}%';
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
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 140),
      children: [
        const _SecaoTitulo(titulo: 'RESUMO'),

        const SizedBox(height: 14),

        GridView.count(
          padding: EdgeInsets.zero,
          crossAxisCount: 2,
          childAspectRatio: 2.85,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          children: [
            _ResumoCard(
              icone: Icons.donut_large,
              titulo: 'COMPLETADO',
              valor: porcentagemGeral,
            ),
            _ResumoCard(
              icone: Icons.collections_bookmark,
              titulo: 'TOTAL',
              valor: figurinhas.length.toString(),
            ),
            _ResumoCard(
              icone: Icons.remove_circle_outline,
              titulo: 'ME FALTAM',
              valor: totalFaltando.toString(),
            ),
            _ResumoCard(
              icone: Icons.check_circle_outline,
              titulo: 'TENHO',
              valor: totalTenho.toString(),
            ),
            _ResumoCard(
              icone: Icons.repeat,
              titulo: 'REPETIDAS',
              valor: totalRepetidas.toString(),
            ),
            _ResumoCard(
              icone: Icons.flag_circle_outlined,
              titulo: 'SELEÇÕES',
              valor: selecoesDisponiveis.length.toString(),
            ),
          ],
        ),

        const SizedBox(height: 26),

        const _SecaoTitulo(titulo: 'PROGRESSO GERAL'),

        const SizedBox(height: 14),

        _ProgressoGeralCard(
          totalTenho: totalTenho,
          totalFigurinhas: figurinhas.length,
          progresso: progressoGeral,
          porcentagem: porcentagemGeral,
        ),

        const SizedBox(height: 26),

        const _SecaoTitulo(titulo: 'PROGRESSO POR SELEÇÃO'),

        const SizedBox(height: 14),

        SizedBox(
          height: 106,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: selecoesDisponiveis.length,
            itemBuilder: (context, index) {
              final selecao = selecoesDisponiveis[index];
              final total = totalPorSelecao(selecao);
              final tenho = totalTenhoPorSelecao(selecao);

              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: ProgressoSelecaoStoryItem(
                  nome: selecao,
                  total: total,
                  tenho: tenho,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 26),

        const _SecaoTitulo(titulo: 'DESTAQUES'),

        const SizedBox(height: 14),

        _DestaqueItem(
          icone: Icons.emoji_events,
          titulo: 'MAIS REPETIDA',
          valor: maisRepetida == null
              ? '-'
              : '${maisRepetida.numeroAlbum} X${maisRepetida.repetidas}',
        ),
        const SizedBox(height: 10),
        _DestaqueItem(
          icone: Icons.star,
          titulo: 'MAIS COMPLETA',
          valor: selecaoMaisCompleta.toUpperCase(),
        ),
        const SizedBox(height: 10),
        _DestaqueItem(
          icone: Icons.warning_amber,
          titulo: 'MAIS FALTANTES',
          valor: selecaoComMaisFaltantes.toUpperCase(),
        ),
      ],
    );
  }
}

class _SecaoTitulo extends StatelessWidget {
  final String titulo;

  const _SecaoTitulo({
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 25,
        fontWeight: FontWeight.w500,
        height: 1,
      ),
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icone,
              color: Colors.black,
              size: 24,
            ),
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
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  valor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressoGeralCard extends StatelessWidget {
  final int totalTenho;
  final int totalFigurinhas;
  final double progresso;
  final String porcentagem;

  const _ProgressoGeralCard({
    required this.totalTenho,
    required this.totalFigurinhas,
    required this.progresso,
    required this.porcentagem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$totalTenho/$totalFigurinhas FIGURINHAS',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 12,
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$porcentagem COMPLETO',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icone,
              color: Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              valor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}