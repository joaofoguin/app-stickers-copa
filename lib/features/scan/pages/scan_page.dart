import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../../../models/figurinha.dart';
import '../../../utils/pais_utils.dart';
import '../models/scan_result.dart';
import '../services/album_scan_service.dart';
import '../services/web_ocr_service.dart';
import '../../../theme/app_colors.dart';
import 'scan_result_page.dart';

class ScanPage extends StatefulWidget {
  final List<Figurinha> figurinhas;

  const ScanPage({
    super.key,
    required this.figurinhas,
  });

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  final AlbumScanService _scanService = AlbumScanService();
  final WebOcrService _webOcrService = WebOcrService();

  final TextEditingController _prefixoController = TextEditingController();
  final TextEditingController _inicioController =
      TextEditingController(text: '1');
  final TextEditingController _fimController =
      TextEditingController(text: '20');
  final TextEditingController _codigosController = TextEditingController();

  bool _carregando = false;
  Uint8List? _imagemBytes;
  String? _ultimoTextoOcr;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mostrarInstrucoesScan();
    });
  }

  void _mostrarInstrucoesScan() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ESCANEIE UMA PÁGINA DO ÁLBUM',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'TIRE OU ESCOLHA UMA FOTO DA PÁGINA INTEIRA, COM BOA ILUMINAÇÃO E OS TEXTOS NA HORIZONTAL.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'O APP TENTARÁ RECONHECER A SELEÇÃO AUTOMATICAMENTE. DEPOIS, VOCÊ CONFIRMA QUAIS FIGURINHAS ESTÃO COLADAS ANTES DE SALVAR.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'DICAS:',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '• DEIXE A PÁGINA RETA\n'
                  '• EVITE SOMBRAS E REFLEXOS\n'
                  '• MANTENHA O NOME DA SELEÇÃO VISÍVEL',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'O RECONHECIMENTO PRECISA DE INTERNET. SE FALHAR, ESCOLHA A SELEÇÃO MANUALMENTE.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'ENTENDI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  late final List<_SelecaoScan> _selecoes = _montarSelecoes();

  _SelecaoScan? _selecaoSelecionada;

  List<_SelecaoScan> _montarSelecoes() {
    final selecoes = <_SelecaoScan>[];

    for (final entrada in siglasPorPais.entries) {
      final nomePais = entrada.key;
      final prefixo = entrada.value;

      final codigos = widget.figurinhas
          .where((figurinha) {
            final numeroAlbum = figurinha.numeroAlbum.toUpperCase().trim();
            return numeroAlbum.startsWith(prefixo);
          })
          .map((figurinha) => figurinha.numeroAlbum.toUpperCase().trim())
          .toSet()
          .toList();

      codigos.sort(_compararCodigos);

      if (codigos.isNotEmpty) {
        selecoes.add(
          _SelecaoScan(
            nome: nomePais,
            prefixo: prefixo,
            codigos: codigos,
          ),
        );
      }
    }

    selecoes.sort((a, b) => a.nome.compareTo(b.nome));

    return selecoes;
  }

  void _girarImagem() {
    if (_imagemBytes == null) return;

    final imagemDecodificada = img.decodeImage(_imagemBytes!);

    if (imagemDecodificada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível girar esta imagem.'),
        ),
      );
      return;
    }

    final imagemRotacionada = img.copyRotate(
      imagemDecodificada,
      angle: 90,
    );

    final novosBytes = Uint8List.fromList(
      img.encodeJpg(imagemRotacionada, quality: 90),
    );

    setState(() {
      _imagemBytes = novosBytes;
      _ultimoTextoOcr = null;
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

  Future<void> _obterImagem(ImageSource source) async {
    final XFile? imagem = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );

    if (imagem == null) return;

    final bytes = await imagem.readAsBytes();

    setState(() {
      _imagemBytes = bytes;
      _ultimoTextoOcr = null;
    });
  }

  Future<void> _selecionarImagem() async {
    await _obterImagem(ImageSource.gallery);
  }

  Future<void> _tirarFoto() async {
    await _obterImagem(ImageSource.camera);
  }

  Future<void> _reconhecerAutomaticamente() async {
    if (_imagemBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escolha uma imagem primeiro.'),
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final textoExtraido = await _webOcrService.reconhecerTexto(_imagemBytes!);

      final resultado = _scanService.processarTextoExtraido(textoExtraido);
      final prefixoDetectado =
          _scanService.detectarPrefixoDoTexto(textoExtraido);

      setState(() {
        _ultimoTextoOcr = textoExtraido;
      });

      if (prefixoDetectado != null) {
        final selecao = _buscarSelecaoPorPrefixo(prefixoDetectado);

        if (selecao != null) {
          setState(() {
            _selecaoSelecionada = selecao;
            _prefixoController.text = selecao.prefixo;
            _inicioController.text = '1';
            _fimController.text = selecao.codigos.length.toString();
            _codigosController.text = selecao.codigos.join(', ');
          });

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Seleção detectada: ${selecao.nome}. Códigos carregados da API.',
              ),
            ),
          );

          return;
        }

        final codigosGerados = _scanService.gerarCodigosPorPrefixo(
          prefixo: prefixoDetectado,
          inicio: 1,
          fim: 20,
        );

        setState(() {
          _prefixoController.text = prefixoDetectado;
          _inicioController.text = '1';
          _fimController.text = '20';
          _codigosController.text = codigosGerados.join(', ');
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Prefixo detectado: $prefixoDetectado. Códigos gerados automaticamente.',
            ),
          ),
        );

        return;
      }

      if (resultado.codigosDetectados.isNotEmpty) {
        setState(() {
          _codigosController.text = resultado.codigosDetectados.join(', ');
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${resultado.codigosDetectados.length} código(s) válido(s) reconhecido(s). Confira antes de continuar.',
            ),
          ),
        );

        return;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não consegui reconhecer com segurança. Escolha a seleção manualmente.',
          ),
        ),
      );
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro no reconhecimento automático: $erro'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  _SelecaoScan? _buscarSelecaoPorPrefixo(String prefixo) {
    final prefixoNormalizado = prefixo.trim().toUpperCase();

    for (final selecao in _selecoes) {
      if (selecao.prefixo.toUpperCase() == prefixoNormalizado) {
        return selecao;
      }
    }

    return null;
  }

  void _aplicarSelecao(_SelecaoScan? selecao) {
    if (selecao == null) return;

    setState(() {
      _selecaoSelecionada = selecao;
      _prefixoController.text = selecao.prefixo;
      _inicioController.text = '1';
      _fimController.text = selecao.codigos.length.toString();
      _codigosController.text = selecao.codigos.join(', ');
    });
  }

  void _gerarCodigos() {
    final prefixo = _prefixoController.text.trim().toUpperCase();
    final inicio = int.tryParse(_inicioController.text.trim());
    final fim = int.tryParse(_fimController.text.trim());

    if (prefixo.isEmpty ||
        inicio == null ||
        fim == null ||
        inicio <= 0 ||
        fim < inicio) {
      _codigosController.clear();
      return;
    }

    final selecao = _buscarSelecaoPorPrefixo(prefixo);

    if (selecao != null) {
      final codigosFiltrados = selecao.codigos.where((codigo) {
        final match = RegExp(r'^([A-Z]+)(\d+)$').firstMatch(codigo);

        if (match == null) return true;

        final numero = int.tryParse(match.group(2)!);

        if (numero == null) return true;

        return numero >= inicio && numero <= fim;
      }).toList();

      codigosFiltrados.sort(_compararCodigos);

      _codigosController.text = codigosFiltrados.join(', ');
      return;
    }

    final codigos = _scanService.gerarCodigosPorPrefixo(
      prefixo: prefixo,
      inicio: inicio,
      fim: fim,
    );

    _codigosController.text = codigos.join(', ');
  }

  Future<void> _continuarParaConfirmacao() async {
    final texto = _codigosController.text.trim();

    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gere, digite ou reconheça ao menos um código.'),
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final ScanResult resultado =
          await _scanService.processarTextoManual(texto);

      if (!mounted) return;

      final codigosJaPossuidos = widget.figurinhas
          .where((figurinha) => figurinha.tenho)
          .map((figurinha) => figurinha.numeroAlbum.toUpperCase().trim())
          .toSet();

      final codigosConfirmados = await Navigator.push<List<String>>(
        context,
        MaterialPageRoute(
          builder: (_) => ScanResultPage(
            resultado: resultado,
            imagemBytes: _imagemBytes,
            codigosJaPossuidos: codigosJaPossuidos,
          ),
        ),
      );

      if (!mounted) return;

      if (codigosConfirmados != null && codigosConfirmados.isNotEmpty) {
        Navigator.pop(context, codigosConfirmados);
      }
    } catch (erro) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao analisar códigos: $erro'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  void _mostrarTextoOcr() {
    final texto = _ultimoTextoOcr?.trim();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Texto reconhecido pelo OCR'),
          content: SingleChildScrollView(
            child: Text(
              texto == null || texto.isEmpty
                  ? 'Nenhum texto foi reconhecido.'
                  : texto,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _prefixoController.dispose();
    _inicioController.dispose();
    _fimController.dispose();
    _codigosController.dispose();
    _scanService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final temImagem = _imagemBytes != null;
    final temTextoOcr =
        _ultimoTextoOcr != null && _ultimoTextoOcr!.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
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

                const SizedBox(height: 28),

                Container(
                  height: 270,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppColors.surfaceLight,
                      width: 1,
                    ),
                  ),
                  child: temImagem
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.memory(
                            _imagemBytes!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          ),
                        )
                      : const _ScanPlaceholderNovo(),
                ),

                const SizedBox(height: 22),

                _ScanButton(
                  label: temImagem ? 'TROCAR IMAGEM' : 'TIRAR FOTO',
                  icon: Icons.photo_camera_outlined,
                  primary: true,
                  onPressed: _carregando ? null : _tirarFoto,
                ),

                const SizedBox(height: 12),

                _ScanButton(
                  label: 'IMPORTAR DA GALERIA',
                  icon: Icons.photo_library_outlined,
                  onPressed: _carregando ? null : _selecionarImagem,
                ),

                const SizedBox(height: 12),

                _ScanButton(
                  label: 'GIRAR IMAGEM',
                  icon: Icons.rotate_90_degrees_cw,
                  onPressed: _carregando || !temImagem ? null : _girarImagem,
                ),

                const SizedBox(height: 12),

                _ScanButton(
                  label: 'RECONHECER AUTOMATICAMENTE',
                  icon: Icons.auto_awesome,
                  onPressed:
                      _carregando || !temImagem ? null : _reconhecerAutomaticamente,
                ),

                if (temTextoOcr) ...[
                  const SizedBox(height: 12),
                  _ScanButton(
                    label: 'VER TEXTO RECONHECIDO',
                    icon: Icons.subject,
                    onPressed: _mostrarTextoOcr,
                  ),
                ],

                const SizedBox(height: 28),

                const Text(
                  'SELEÇÃO IDENTIFICADA',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<_SelecaoScan>(
                            value: _selecaoSelecionada,
                            dropdownColor: AppColors.surface,
                            isExpanded: true,
                            hint: const Text(
                              'ESCOLHA A SELEÇÃO',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            items: _selecoes.map((selecao) {
                              return DropdownMenuItem<_SelecaoScan>(
                                value: selecao,
                                child: Text(
                                  '${selecao.nome} (${selecao.prefixo})'
                                      .toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: _carregando ? null : _aplicarSelecao,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                if (_selecaoSelecionada != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Text(
                          bandeiraEmojiPais(_selecaoSelecionada!.nome),
                          style: const TextStyle(fontSize: 30),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            '${_selecaoSelecionada!.nome} (${_selecaoSelecionada!.prefixo})'
                                .toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '${_selecaoSelecionada!.codigos.length}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _prefixoController,
                        enabled: !_carregando,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          hintText: 'PREFIXO',
                        ),
                        onChanged: (_) => _gerarCodigos(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _inicioController,
                        enabled: !_carregando,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'INÍCIO',
                        ),
                        onChanged: (_) => _gerarCodigos(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _fimController,
                        enabled: !_carregando,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'FIM',
                        ),
                        onChanged: (_) => _gerarCodigos(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: _codigosController,
                  enabled: !_carregando,
                  minLines: 3,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    hintText: 'CÓDIGOS RECONHECIDOS OU GERADOS',
                  ),
                ),

                const SizedBox(height: 18),

                if (_carregando)
                  const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 14),
                      Text(
                        'ANALISANDO IMAGEM...',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                else
                  _ScanButton(
                    label: 'CONTINUAR',
                    icon: Icons.arrow_forward,
                    primary: true,
                    onPressed: _continuarParaConfirmacao,
                  ),

                const SizedBox(height: 18),

                const Text(
                  'O RECONHECIMENTO AUTOMÁTICO É APENAS UMA AJUDA. SEMPRE CONFIRA OS CÓDIGOS ANTES DE CONTINUAR.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),

            if (_carregando)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withAlpha(60),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ScanPlaceholderNovo extends StatelessWidget {
  const _ScanPlaceholderNovo();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.document_scanner_outlined,
            color: AppColors.textPrimary,
            size: 82,
          ),
          SizedBox(height: 20),
          Text(
            'ESCOLHA UMA FOTO DA PÁGINA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'O APP TENTARÁ RECONHECER A SELEÇÃO AUTOMATICAMENTE.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelecaoScan {
  final String nome;
  final String prefixo;
  final List<String> codigos;

  const _SelecaoScan({
    required this.nome,
    required this.prefixo,
    required this.codigos,
  });
}

class _ScanButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool primary;

  const _ScanButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = primary
        ? AppColors.primaryBlue
        : AppColors.surfaceLight;

    final foregroundColor = primary ? Colors.black : AppColors.textPrimary;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: AppColors.surface,
          disabledForegroundColor: AppColors.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}