import 'package:flutter/material.dart';

import '../features/scan/pages/scan_page.dart';
import '../models/figurinha.dart';
import '../pages/colecao_page.dart';
import '../pages/estatisticas_page.dart';
import '../services/figurinha_service.dart';
import '../storage/colecao_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FigurinhaService figurinhaService = FigurinhaService();
  final ColecaoStorage colecaoStorage = ColecaoStorage();

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

  Future<void> abrirScanPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanPage(),
      ),
    );

    await carregarFigurinhasDaApi();
  }

  void trocarTela(int indice) {
    setState(() {
      indiceTelaAtual = indice;
    });
  }

  Widget construirTelaErro() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Álbum de Seleções'),
        centerTitle: true,
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
      title: const Text('Álbum de Seleções'),
      centerTitle: true,
      actions: [
        IconButton(
          tooltip: 'Escanear página',
          icon: const Icon(Icons.document_scanner_outlined),
          onPressed: abrirScanPage,
        ),
        PopupMenuButton<String>(
          tooltip: 'Mais opções',
          onSelected: (valor) {
            if (valor == 'limpar') {
              confirmarLimpezaAlbum();
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: 'limpar',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(width: 12),
                    Text('Limpar coleção'),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
      bottom: indiceTelaAtual == 0
          ? const TabBar(
              tabs: [
                Tab(text: 'Todas'),
                Tab(text: 'Faltantes'),
                Tab(text: 'Repetidas'),
              ],
            )
          : null,
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
      );
    }

    return EstatisticasPage(
      figurinhas: figurinhas,
    );
  }

  NavigationBar construirNavigationBar() {
    return NavigationBar(
      selectedIndex: indiceTelaAtual,
      onDestinationSelected: trocarTela,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.collections_bookmark_outlined),
          selectedIcon: Icon(Icons.collections_bookmark),
          label: 'Coleção',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart),
          label: 'Estatísticas',
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
        appBar: construirAppBar(),
        body: construirBody(),
        bottomNavigationBar: construirNavigationBar(),
      ),
    );
  }
}