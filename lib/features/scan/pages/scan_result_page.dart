import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../models/scan_result.dart';
import 'scan_success_page.dart';

class ScanResultPage extends StatefulWidget {
  final ScanResult resultado;
  final Uint8List? imagemBytes;
  final Set<String> codigosJaPossuidos;

  const ScanResultPage({
    super.key,
    required this.resultado,
    this.imagemBytes,
    this.codigosJaPossuidos = const {},
  });

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  final Set<String> _figurinhasSelecionadas = {};

  Future<void> _confirmarFigurinhas() async {
    final figurinhas = _figurinhasSelecionadas.toList();

    figurinhas.sort(_compararCodigos);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanSuccessPage(
          totalFigurinhas: figurinhas.length,
        ),
      ),
    );

    if (!mounted) return;

    Navigator.pop(context, figurinhas);
  }

  void _selecionarTodas() {
    setState(() {
      _figurinhasSelecionadas
        ..clear()
        ..addAll(
          widget.resultado.codigosDetectados.where((codigo) {
            final normalizado = codigo.toUpperCase().trim();

            return !widget.codigosJaPossuidos.contains(normalizado);
          }).map((codigo) {
            return codigo.toUpperCase().trim();
          }),
        );
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

  String _prefixoCodigo(String codigo) {
    final match = RegExp(r'^([A-Z]+)').firstMatch(codigo.toUpperCase().trim());

    return match?.group(1) ?? codigo.toUpperCase().trim();
  }

  String _numeroCodigo(String codigo) {
    final match = RegExp(r'(\d+)').firstMatch(codigo.toUpperCase().trim());

    return match?.group(1) ?? codigo.toUpperCase().trim();
  }

  @override
  Widget build(BuildContext context) {
    final codigos = [...widget.resultado.codigosDetectados];
    codigos.sort(_compararCodigos);

    final encontrouCodigos = codigos.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: AppColors.textPrimary,
                          size: 32,
                        ),
                        Text(
                          'VOLTAR',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (widget.imagemBytes != null) ...[
                    Container(
                      height: 230,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColors.surfaceLight,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.memory(
                          widget.imagemBytes!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  _ResumoScanCard(
                    totalSelecionadas: _figurinhasSelecionadas.length,
                  ),

                  const SizedBox(height: 16),

                  if (encontrouCodigos)
                    Row(
                      children: [
                        _AcaoTextoScan(
                          icone: Icons.select_all,
                          texto: 'TODAS',
                          onTap: _selecionarTodas,
                        ),
                        const SizedBox(width: 18),
                        _AcaoTextoScan(
                          icone: Icons.clear,
                          texto: 'LIMPAR',
                          onTap: _limparSelecao,
                        ),
                      ],
                    ),

                  const SizedBox(height: 18),

                  if (encontrouCodigos)
                    GridView.builder(
                      itemCount: codigos.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.05,
                      ),
                      itemBuilder: (context, index) {
                        final codigo = codigos[index];
                        final codigoNormalizado = codigo.toUpperCase().trim();

                        final jaPossui = widget.codigosJaPossuidos.contains(
                          codigoNormalizado,
                        );

                        final selecionada =
                            _figurinhasSelecionadas.contains(codigoNormalizado);

                        return _CodigoFigurinhaTile(
                          prefixo: _prefixoCodigo(codigo),
                          numero: _numeroCodigo(codigo),
                          selecionada: selecionada,
                          jaPossui: jaPossui,
                          onTap: jaPossui
                              ? null
                              : () {
                                  setState(() {
                                    if (selecionada) {
                                      _figurinhasSelecionadas.remove(
                                        codigoNormalizado,
                                      );
                                    } else {
                                      _figurinhasSelecionadas.add(
                                        codigoNormalizado,
                                      );
                                    }
                                  });
                                },
                        );
                      },
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Text(
                        'NENHUM CÓDIGO FOI ENCONTRADO.\n\nVOLTE E ESCOLHA UMA SELEÇÃO OU DIGITE CÓDIGOS COMO MEX1, MEX2 OU BRA10.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00000000),
                    Color(0xCC000000),
                    Color(0xFF000000),
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _figurinhasSelecionadas.isEmpty
                        ? null
                        : _confirmarFigurinhas,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: AppColors.surface,
                      disabledForegroundColor: AppColors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'CONFIRMAR ${_figurinhasSelecionadas.length} FIGURINHA(S)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumoScanCard extends StatelessWidget {
  final int totalSelecionadas;

  const _ResumoScanCard({
    required this.totalSelecionadas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.textPrimary,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '$totalSelecionadas SELECIONADA(S) COMO POSSUÍDA(S)',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AcaoTextoScan extends StatelessWidget {
  final IconData icone;
  final String texto;
  final VoidCallback onTap;

  const _AcaoTextoScan({
    required this.icone,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icone,
            color: AppColors.textPrimary,
            size: 18,
          ),
          const SizedBox(width: 5),
          Text(
            texto,
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

class _CodigoFigurinhaTile extends StatelessWidget {
  final String prefixo;
  final String numero;
  final bool selecionada;
  final bool jaPossui;
  final VoidCallback? onTap;

  const _CodigoFigurinhaTile({
    required this.prefixo,
    required this.numero,
    required this.selecionada,
    required this.jaPossui,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final marcadaVisualmente = selecionada || jaPossui;

    final backgroundColor = marcadaVisualmente
        ? const Color(0xFFE4F6E7)
        : const Color(0xFFBDBDBD);

    final borderColor = jaPossui
        ? AppColors.surfaceLight
        : selecionada
            ? AppColors.successGreen
            : Colors.transparent;

    return Opacity(
      opacity: jaPossui ? 0.55 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: marcadaVisualmente ? 2.2 : 0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(80),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 6, 6, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        prefixo.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        numero,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (marcadaVisualmente)
                Positioned(
                  left: 5,
                  bottom: 5,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      color: jaPossui
                          ? AppColors.surfaceLight
                          : AppColors.successGreen,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      jaPossui ? Icons.lock : Icons.check,
                      size: 11,
                      color: Colors.white,
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