import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/figurinha.dart';
import '../utils/album_sort.dart';
import '../widgets/secao_pais_grid.dart';
import '../widgets/selecao_story_item.dart';

enum TipoListaColecao {
  todas,
  faltantes,
  repetidas,
}

class ColecaoPage extends StatelessWidget {
  final List<Figurinha> figurinhas;
  final String textoBusca;
  final String selecaoSelecionada;
  final ValueChanged<String> onBuscaChanged;
  final ValueChanged<String> onSelecaoChanged;
  final void Function(Figurinha figurinha, bool valor) onMarcar;
  final void Function(Figurinha figurinha) onAdicionarRepetida;
  final void Function(Figurinha figurinha) onRemoverRepetida;
  final Future<void> Function() onAtualizar;

  const ColecaoPage({
    super.key,
    required this.figurinhas,
    required this.textoBusca,
    required this.selecaoSelecionada,
    required this.onBuscaChanged,
    required this.onSelecaoChanged,
    required this.onMarcar,
    required this.onAdicionarRepetida,
    required this.onRemoverRepetida,
    required this.onAtualizar,
  });

  int get totalTenho {
    return figurinhas.where((figurinha) => figurinha.tenho).length;
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

    return ['Todas', ...selecoes];
  }

  List<Figurinha> get figurinhasFiltradas {
    final busca = textoBusca.toLowerCase();

    final lista = figurinhas.where((figurinha) {
      final correspondeBusca = textoBusca.isEmpty ||
          figurinha.numeroAlbum.toLowerCase().contains(busca) ||
          figurinha.pais.toLowerCase().contains(busca) ||
          figurinha.nome.toLowerCase().contains(busca);

      final correspondeSelecao = selecaoSelecionada == 'Todas' ||
          figurinha.pais == selecaoSelecionada;

      return correspondeBusca && correspondeSelecao;
    }).toList();

    lista.sort(compararFigurinhasAlbum);

    return lista;
  }

  List<Figurinha> get figurinhasFaltantesFiltradas {
    return figurinhasFiltradas.where((figurinha) => !figurinha.tenho).toList();
  }

  List<Figurinha> get figurinhasRepetidasFiltradas {
    return figurinhasFiltradas.where((figurinha) {
      return figurinha.repetidas > 0;
    }).toList();
  }

  int totalPorSelecao(String selecao) {
    if (selecao == 'Todas') {
      return figurinhas.length;
    }

    return figurinhas.where((figurinha) => figurinha.pais == selecao).length;
  }

  int totalTenhoPorSelecao(String selecao) {
    if (selecao == 'Todas') {
      return totalTenho;
    }

    return figurinhas.where((figurinha) {
      return figurinha.pais == selecao && figurinha.tenho;
    }).length;
  }

  Map<String, List<Figurinha>> agruparPorSelecao(List<Figurinha> lista) {
    final grupos = LinkedHashMap<String, List<Figurinha>>();

    for (final figurinha in lista) {
      grupos.putIfAbsent(figurinha.pais, () => []);
      grupos[figurinha.pais]!.add(figurinha);
    }

    return grupos;
  }

  String resumoSecao(
    String selecao,
    List<Figurinha> itens,
    TipoListaColecao tipo,
  ) {
    switch (tipo) {
      case TipoListaColecao.todas:
        final tenho = totalTenhoPorSelecao(selecao);
        final total = totalPorSelecao(selecao);
        return '$tenho de $total';

      case TipoListaColecao.faltantes:
        return '${itens.length} faltando';

      case TipoListaColecao.repetidas:
        return '${itens.length} repetidas';
    }
  }

  Widget construirGradeAgrupada(
    BuildContext context,
    List<Figurinha> lista, {
    required TipoListaColecao tipo,
  }) {
    if (lista.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 200),
          Center(
            child: Text(
              'Nenhuma figurinha encontrada',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      );
    }

    final grupos = agruparPorSelecao(lista);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
      children: grupos.entries.map((entry) {
        final pais = entry.key;
        final itens = entry.value;

        return SecaoPaisGrid(
          pais: pais,
          figurinhas: itens,
          totalPais: totalPorSelecao(pais),
          tenhoPais: totalTenhoPorSelecao(pais),
          resumo: resumoSecao(pais, itens, tipo),
          onMarcar: onMarcar,
          onAdicionarRepetida: onAdicionarRepetida,
          onRemoverRepetida: onRemoverRepetida,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Buscar figurinha',
              hintText: 'Digite número, país ou nome',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: onBuscaChanged,
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 104,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: selecoesDisponiveis.length,
            itemBuilder: (context, index) {
              final selecao = selecoesDisponiveis[index];

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SelecaoStoryItem(
                  nome: selecao,
                  total: totalPorSelecao(selecao),
                  tenho: totalTenhoPorSelecao(selecao),
                  selecionado: selecaoSelecionada == selecao,
                  onTap: () {
                    onSelecaoChanged(selecao);
                  },
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        Expanded(
          child: TabBarView(
            children: [
              RefreshIndicator(
                onRefresh: onAtualizar,
                child: construirGradeAgrupada(
                  context,
                  figurinhasFiltradas,
                  tipo: TipoListaColecao.todas,
                ),
              ),
              RefreshIndicator(
                onRefresh: onAtualizar,
                child: construirGradeAgrupada(
                  context,
                  figurinhasFaltantesFiltradas,
                  tipo: TipoListaColecao.faltantes,
                ),
              ),
              RefreshIndicator(
                onRefresh: onAtualizar,
                child: construirGradeAgrupada(
                  context,
                  figurinhasRepetidasFiltradas,
                  tipo: TipoListaColecao.repetidas,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}