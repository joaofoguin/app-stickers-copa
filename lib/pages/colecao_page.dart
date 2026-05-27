import 'dart:collection';

import 'package:flutter/material.dart';

import '../models/figurinha.dart';
import '../utils/album_sort.dart';
import '../widgets/colecao_tab_selector.dart';
import '../widgets/secao_pais_grid.dart';
import '../widgets/selecao_story_item.dart';

enum TipoListaColecao {
  todas,
  faltantes,
  repetidas,
}

class ColecaoPage extends StatefulWidget {
  final List<Figurinha> figurinhas;
  final String textoBusca;
  final String selecaoSelecionada;
  final ValueChanged<String> onBuscaChanged;
  final ValueChanged<String> onSelecaoChanged;
  final void Function(Figurinha figurinha, bool valor) onMarcar;
  final void Function(Figurinha figurinha) onAdicionarRepetida;
  final void Function(Figurinha figurinha) onRemoverRepetida;
  final void Function(String mensagem) onMostrarMensagem;
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
    required this.onMostrarMensagem,
  });

  @override
  State<ColecaoPage> createState() => _ColecaoPageState();
}

class _ColecaoPageState extends State<ColecaoPage> {
  late final TextEditingController buscaController;

  @override
  void initState() {
    super.initState();

    buscaController = TextEditingController(
      text: widget.textoBusca,
    );
  }

  @override
  void didUpdateWidget(covariant ColecaoPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.textoBusca != buscaController.text) {
      buscaController.text = widget.textoBusca;

      buscaController.selection = TextSelection.collapsed(
        offset: buscaController.text.length,
      );
    }
  }

  @override
  void dispose() {
    buscaController.dispose();
    super.dispose();
  }

  bool get temFiltroAtivo {
    return widget.textoBusca.trim().isNotEmpty ||
        widget.selecaoSelecionada != 'Todas';
  }

  int get totalTenho {
    return widget.figurinhas.where((figurinha) => figurinha.tenho).length;
  }

  List<String> get selecoesDisponiveis {
    final Map<String, int> ordemPorPais = {};

    for (final figurinha in widget.figurinhas) {
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
    final busca = widget.textoBusca.trim().toLowerCase();

    final lista = widget.figurinhas.where((figurinha) {
      final correspondeBusca = busca.isEmpty ||
          figurinha.numeroAlbum.toLowerCase().contains(busca) ||
          figurinha.pais.toLowerCase().contains(busca) ||
          figurinha.nome.toLowerCase().contains(busca);

      final correspondeSelecao = widget.selecaoSelecionada == 'Todas' ||
          figurinha.pais == widget.selecaoSelecionada;

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
      return widget.figurinhas.length;
    }

    return widget.figurinhas.where((figurinha) {
      return figurinha.pais == selecao;
    }).length;
  }

  int totalTenhoPorSelecao(String selecao) {
    if (selecao == 'Todas') {
      return totalTenho;
    }

    return widget.figurinhas.where((figurinha) {
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

  void limparBusca() {
    buscaController.clear();
    widget.onBuscaChanged('');
  }

  void limparFiltros() {
    buscaController.clear();
    widget.onBuscaChanged('');
    widget.onSelecaoChanged('Todas');
  }

  Widget construirTabSelector() {
    return Builder(
      builder: (context) {
        final tabController = DefaultTabController.of(context);

        return AnimatedBuilder(
          animation: tabController,
          builder: (context, _) {
            return ColecaoTabSelector(
              indiceAtual: tabController.index,
              onChanged: (indice) {
                tabController.animateTo(indice);
              },
            );
          },
        );
      },
    );
  }

  Widget construirBotaoLimparFiltros() {
    if (!temFiltroAtivo) {
      return const SizedBox.shrink();
    }

    final textoBuscaAtivo = widget.textoBusca.trim().isNotEmpty;
    final selecaoAtiva = widget.selecaoSelecionada != 'Todas';

    String textoBotao = 'LIMPAR FILTROS';

    if (textoBuscaAtivo && !selecaoAtiva) {
      textoBotao = 'LIMPAR BUSCA';
    } else if (!textoBuscaAtivo && selecaoAtiva) {
      textoBotao = 'VOLTAR PARA TODAS';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: limparFiltros,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF4A4A4A),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  textoBotao,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          SizedBox(height: 96),
          Center(
            child: Text(
              'NENHUMA FIGURINHA ENCONTRADA',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      );
    }

    final grupos = agruparPorSelecao(lista);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 170),
      children: grupos.entries.map((entry) {
        final pais = entry.key;
        final itens = entry.value;

        return SecaoPaisGrid(
          pais: pais,
          figurinhas: itens,
          totalPais: totalPorSelecao(pais),
          tenhoPais: totalTenhoPorSelecao(pais),
          resumo: resumoSecao(pais, itens, tipo),
          onMarcar: widget.onMarcar,
          onAdicionarRepetida: widget.onAdicionarRepetida,
          onRemoverRepetida: widget.onRemoverRepetida,
          onMostrarMensagem: widget.onMostrarMensagem,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        construirTabSelector(),

        Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
          child: TextField(
            controller: buscaController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'BUSCAR FIGURINHA',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.textoBusca.isNotEmpty
                  ? IconButton(
                      onPressed: limparBusca,
                      icon: const Icon(Icons.close),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onChanged: widget.onBuscaChanged,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            itemCount: selecoesDisponiveis.length,
            itemBuilder: (context, index) {
              final selecao = selecoesDisponiveis[index];

              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: SelecaoStoryItem(
                  nome: selecao,
                  total: totalPorSelecao(selecao),
                  tenho: totalTenhoPorSelecao(selecao),
                  selecionado: widget.selecaoSelecionada == selecao,
                  onTap: () {
                    widget.onSelecaoChanged(selecao);
                  },
                ),
              );
            },
          ),
        ),

        construirBotaoLimparFiltros(),

        Expanded(
          child: TabBarView(
            children: [
              RefreshIndicator(
                onRefresh: widget.onAtualizar,
                child: construirGradeAgrupada(
                  context,
                  figurinhasFiltradas,
                  tipo: TipoListaColecao.todas,
                ),
              ),
              RefreshIndicator(
                onRefresh: widget.onAtualizar,
                child: construirGradeAgrupada(
                  context,
                  figurinhasFaltantesFiltradas,
                  tipo: TipoListaColecao.faltantes,
                ),
              ),
              RefreshIndicator(
                onRefresh: widget.onAtualizar,
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