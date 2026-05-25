import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/scan_result.dart';

class ScanResultPage extends StatefulWidget {
  final ScanResult resultado;
  final Uint8List? imagemBytes;

  const ScanResultPage({
    super.key,
    required this.resultado,
    this.imagemBytes,
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (widget.imagemBytes != null) ...[
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      widget.imagemBytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              _ResumoScanCard(
                totalCodigos: codigos.length,
                totalSelecionadas: _figurinhasSelecionadas.length,
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Toque nas figurinhas que estão coladas no álbum:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
                    ? GridView.builder(
                        itemCount: codigos.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 110,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 1.35,
                        ),
                        itemBuilder: (context, index) {
                          final codigo = codigos[index];
                          final selecionada =
                              _figurinhasSelecionadas.contains(codigo);

                          return _CodigoFigurinhaTile(
                            codigo: codigo,
                            selecionada: selecionada,
                            onTap: () {
                              setState(() {
                                if (selecionada) {
                                  _figurinhasSelecionadas.remove(codigo);
                                } else {
                                  _figurinhasSelecionadas.add(codigo);
                                }
                              });
                            },
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'Nenhum código foi encontrado.\n\nVolte e escolha uma seleção ou digite códigos como MEX1, MEX2 ou BRA10.',
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

class _CodigoFigurinhaTile extends StatelessWidget {
  final String codigo;
  final bool selecionada;
  final VoidCallback onTap;

  const _CodigoFigurinhaTile({
    required this.codigo,
    required this.selecionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: selecionada
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selecionada
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: selecionada ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Stack(
            children: [
              Center(
                child: Text(
                  codigo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selecionada
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (selecionada)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 22,
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
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(Icons.checklist_outlined, size: 32),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$totalCodigos código(s) na página',
                    style: const TextStyle(
                      fontSize: 15,
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