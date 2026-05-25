import 'package:flutter/material.dart';

class ConfiguracoesPage extends StatelessWidget {
  final Future<void> Function() onAtualizarCatalogo;
  final Future<void> Function() onLimparColecao;
  final int totalFigurinhas;

  const ConfiguracoesPage({
    super.key,
    required this.onAtualizarCatalogo,
    required this.onLimparColecao,
    required this.totalFigurinhas,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Configurações',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.sync),
                title: const Text('Atualizar catálogo'),
                subtitle: const Text(
                  'Busca novamente as figurinhas na API online',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await onAtualizarCatalogo();

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Catálogo atualizado'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Limpar coleção'),
                subtitle: const Text(
                  'Remove todas as marcações e repetidas salvas',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await onLimparColecao();
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_outlined),
                title: const Text('Origem dos dados'),
                subtitle: const Text('Catálogo carregado pela API online'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.collections_bookmark_outlined),
                title: const Text('Total no catálogo'),
                subtitle: Text('$totalFigurinhas figurinhas carregadas'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Card(
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Sobre o app'),
                subtitle: Text('Álbum de Seleções'),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.verified_outlined),
                title: Text('Versão'),
                subtitle: Text('1.0.0'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}