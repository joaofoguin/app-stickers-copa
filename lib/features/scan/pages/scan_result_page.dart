import 'package:flutter/material.dart';

import '../models/scan_result.dart';

class ScanResultPage extends StatefulWidget {
  final ScanResult resultado;

  const ScanResultPage({
    super.key,
    required this.resultado,
  });

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  final Set<String> _figurinhasSelecionadas = {};

void _confirmarFigurinhas() {
  final figurinhas = _figurinhasSelecionadas.toList();

  figurinhas.sort(_compararCodigos);

  Navigator.pop(context, figurinhas);
}

  void _selecionarTodas() {
    setState(() {
      _figurinhasSelecionadas
        ..clear()
        ..addAll(widget.resultado.codigosDetectados);
    });
  }

  void _limparSelecao() {
    setState(() {
      _figurinhasSelecionadas.clear();
    });
  }

  int _compararCodigos(String a, String b) {
    final regex = RegExp(r'^([A-Z]+)(\d+)$');

    final matchA = regex.firstMatch(a);
    final matchB = regex.firstMatch(b);

    if (matchA == null || matchB == null) {
      return a.compareTo(b);
    }

    final prefixoA = matchA.group(1)!;
    final prefixoB = matchB.group(1)!;

    final comparacaoPrefixo = prefixoA.compareTo(prefixoB);

    if (comparacaoPrefixo != 0) {
      return comparacaoPrefixo;
    }

    final numeroA = int.parse(matchA.group(2)!);
    final numeroB = int.parse(matchB.group(2)!);

    return numeroA.compareTo(numeroB);
  }

  @override
  Widget build(BuildContext context) {
    final codigos = widget.resultado.codigosDetectados;
    final encontrouCodigos = codigos.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar figurinhas'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ResumoScanCard(
                totalCodigos: codigos.length,
                totalSelecionadas: _figurinhasSelecionadas.length,
              ),
              const SizedBox(height: 20),
              const Text(
                'Marque apenas as figurinhas que estão coladas no álbum:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if (encontrouCodigos)
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: _selecionarTodas,
                      icon: const Icon(Icons.select_all),
                      label: const Text('Todas'),
                    ),
                    TextButton.icon(
                      onPressed: _limparSelecao,
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpar'),
                    ),
                  ],
                ),
              Expanded(
                child: encontrouCodigos
                    ? ListView.separated(
                        itemCount: codigos.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final codigo = codigos[index];
                          final selecionada =
                              _figurinhasSelecionadas.contains(codigo);

                          return CheckboxListTile(
                            value: selecionada,
                            title: Text(
                              codigo,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              selecionada
                                  ? 'Será marcada como possuída'
                                  : 'Ainda não selecionada',
                            ),
                            onChanged: (valor) {
                              setState(() {
                                if (valor == true) {
                                  _figurinhasSelecionadas.add(codigo);
                                } else {
                                  _figurinhasSelecionadas.remove(codigo);
                                }
                              });
                            },
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'Nenhum código foi encontrado.\n\nVolte e digite códigos como MEX1, MEX2 ou BRA10.',
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _figurinhasSelecionadas.isEmpty
                      ? null
                      : _confirmarFigurinhas,
                  icon: const Icon(Icons.check),
                  label: Text(
                    'Confirmar ${_figurinhasSelecionadas.length} figurinha(s)',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumoScanCard extends StatelessWidget {
  final int totalCodigos;
  final int totalSelecionadas;

  const _ResumoScanCard({
    required this.totalCodigos,
    required this.totalSelecionadas,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.checklist_outlined, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$totalCodigos código(s) na página',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalSelecionadas selecionada(s) como possuída(s)',
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