import 'package:flutter/material.dart';

import '../features/scan/pages/scan_page.dart';
import '../models/figurinha.dart';
import '../pages/colecao_page.dart';
import '../pages/estatisticas_page.dart';
import '../services/figurinha_service.dart';
import '../storage/colecao_storage.dart';
import '../pages/configuracoes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FigurinhaService figurinhaService = FigurinhaService();
  final ColecaoStorage colecaoStorage = ColecaoStorage();

  bool notificacaoVisivel = false;
  String? mensagemNotificacao;
  List<Figurinha> figurinhas = [];
  bool carregando = true;
  String? erroCarregamento;
  String textoBusca = '';
  String selecaoSelecionada = 'Todas';
  int indiceTelaAtual = 0;

  @override
  void initState() {
    super.initState();
    carregarFigurinhasDaApi();
  }

  Future<void> mostrarSnackBar(String mensagem) async {
    if (!mounted) return;

    setState(() {
      mensagemNotificacao = mensagem.toUpperCase();
      notificacaoVisivel = true;
    });

    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    setState(() {
      notificacaoVisivel = false;
    });

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    setState(() {
      mensagemNotificacao = null;
    });
  }

  Future<void> carregarFigurinhasDaApi() async {
    try {
      debugPrint('Chamando API...');

      final figurinhasApi = await figurinhaService.listarFigurinhas();

      debugPrint('API retornou ${figurinhasApi.length} figurinhas');

      try {
        await colecaoStorage.carregarDadosSalvos(figurinhasApi);
        debugPrint('Dados locais carregados');
      } catch (erroStorage) {
        debugPrint('Erro ao carregar SQLite/storage: $erroStorage');
      }

      if (!mounted) return;

      setState(() {
        figurinhas = figurinhasApi;
        carregando = false;
        erroCarregamento = null;
      });
    } catch (erroApi) {
      debugPrint('Erro ao carregar API: $erroApi');

      if (!mounted) return;

      setState(() {
        carregando = false;
        erroCarregamento = 'Não foi possível carregar as figurinhas da API.';
      });
    }
  }

  void marcarFigurinha(Figurinha figurinha, bool valor) {
    setState(() {
      figurinha.tenho = valor;

      if (!valor) {
        figurinha.repetidas = 0;
      }
    });

    colecaoStorage.salvarFigurinha(figurinha);
  }

  void marcarFigurinhasPorCodigo(List<String> codigos) {
    final codigosNormalizados = codigos
        .map((codigo) => codigo.toUpperCase().trim())
        .toSet();

    final figurinhasEncontradas = figurinhas.where((figurinha) {
      return codigosNormalizados.contains(
        figurinha.numeroAlbum.toUpperCase().trim(),
      );
    }).toList();

    setState(() {
      for (final figurinha in figurinhasEncontradas) {
        figurinha.tenho = true;
      }
    });

    for (final figurinha in figurinhasEncontradas) {
      colecaoStorage.salvarFigurinha(figurinha);
    }

    final totalNaoEncontradas =
        codigosNormalizados.length - figurinhasEncontradas.length;

    mostrarSnackBar(
      totalNaoEncontradas == 0
          ? '${figurinhasEncontradas.length} figurinha(s) marcada(s) como possuída(s).'
          : '${figurinhasEncontradas.length} marcada(s). $totalNaoEncontradas código(s) não encontrado(s).',
    );
  }

  void adicionarRepetida(Figurinha figurinha) {
    setState(() {
      figurinha.repetidas++;
      figurinha.tenho = true;
    });

    colecaoStorage.salvarFigurinha(figurinha);
  }

  void removerRepetida(Figurinha figurinha) {
    if (figurinha.repetidas == 0) return;

    setState(() {
      figurinha.repetidas--;
    });

    colecaoStorage.salvarFigurinha(figurinha);
  }

  Future<void> confirmarLimpezaAlbum() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Limpar coleção'),
          content: const Text(
            'Tem certeza que deseja apagar todas as marcações e repetidas?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Limpar'),
            ),
          ],
        );
      },
    );

    if (confirmou == true) {
      await colecaoStorage.limparAlbum(figurinhas);

      if (!mounted) return;

      setState(() {});
    }
  }

  Future<void> abrirScan() async {
    final codigosConfirmados = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => ScanPage(
          figurinhas: figurinhas,
        ),
      ),
    );

    if (codigosConfirmados == null || codigosConfirmados.isEmpty) return;

    final codigosNormalizados = codigosConfirmados
        .map((codigo) => codigo.toUpperCase().trim())
        .toSet();

    final figurinhasConfirmadas = figurinhas.where((figurinha) {
      return codigosNormalizados.contains(
        figurinha.numeroAlbum.toUpperCase().trim(),
      );
    }).toList();

    if (figurinhasConfirmadas.isEmpty) {
      if (!mounted) return;

      mostrarSnackBar(
        'NENHUMA FIGURINHA DO SCAN FOI ENCONTRADA NA COLEÇÃO',
      );
      return;
    }

    await colecaoStorage.marcarVariasComoTenho(figurinhasConfirmadas);

    if (!mounted) return;

    setState(() {});

    mostrarSnackBar(
      '${figurinhasConfirmadas.length} FIGURINHA(S) MARCADA(S) PELO SCAN',
    );
  }

  void trocarTela(int indice) {
    setState(() {
      indiceTelaAtual = indice;
    });
  }

  Widget construirTelaErro() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                erroCarregamento!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    carregando = true;
                    erroCarregamento = null;
                  });

                  carregarFigurinhasDaApi();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget construirAppBar() {
    return AppBar(
      toolbarHeight: 0,
      elevation: 0,
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
    );
  }

  Widget construirBody() {
    if (indiceTelaAtual == 0) {
      return ColecaoPage(
        figurinhas: figurinhas,
        textoBusca: textoBusca,
        selecaoSelecionada: selecaoSelecionada,
        onBuscaChanged: (valor) {
          setState(() {
            textoBusca = valor;
          });
        },
        onSelecaoChanged: (valor) {
          setState(() {
            selecaoSelecionada = valor;
          });
        },
        onMarcar: marcarFigurinha,
        onAdicionarRepetida: adicionarRepetida,
        onRemoverRepetida: removerRepetida,
        onAtualizar: carregarFigurinhasDaApi,
        onMostrarMensagem: mostrarSnackBar,
      );
    }

    if (indiceTelaAtual == 1) {
      return EstatisticasPage(
        figurinhas: figurinhas,
      );
    }

    return ConfiguracoesPage(
      totalFigurinhas: figurinhas.length,
      onAtualizarCatalogo: carregarFigurinhasDaApi,
      onLimparColecao: confirmarLimpezaAlbum,
      onMostrarMensagem: mostrarSnackBar,
    );
  }

  NavigationBar construirNavigationBar() {
    return NavigationBar(
      height: 74,
      backgroundColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      selectedIndex: indiceTelaAtual,
      onDestinationSelected: trocarTela,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.collections_bookmark_outlined),
          selectedIcon: Icon(Icons.collections_bookmark),
          label: 'COLEÇÃO',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart),
          label: 'ESTATÍSTICAS',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'CONFIG.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (erroCarregamento != null) {
      return construirTelaErro();
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              construirBody(),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                left: 16,
                right: 16,
                bottom: notificacaoVisivel ? 88 : 40,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: notificacaoVisivel ? 1 : 0,
                    child: mensagemNotificacao == null
                        ? const SizedBox.shrink()
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF555555),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(120),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Text(
                              mensagemNotificacao!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                  ),
                ),
              ),

              if (indiceTelaAtual == 0)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  right: 16,
                  bottom: notificacaoVisivel ? 158 : 88,
                  child: FloatingActionButton(
                    onPressed: abrirScan,
                    backgroundColor: const Color(0xFF0A84FF),
                    foregroundColor: Colors.black,
                    elevation: 8,
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.document_scanner_outlined,
                      size: 30,
                    ),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x00000000),
                Color(0x77000000),
                Color(0xEE000000),
              ],
              stops: [
                0.0,
                0.45,
                1.0,
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: construirNavigationBar(),
          ),
        ),
      ),
    );
  }
}