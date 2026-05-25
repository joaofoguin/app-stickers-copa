import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import '../../../models/figurinha.dart';
import '../../../utils/pais_utils.dart';
import '../models/scan_result.dart';
import '../services/album_scan_service.dart';
import '../services/web_ocr_service.dart';
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

  Future<void> _selecionarImagem() async {
    final XFile? imagem = await _picker.pickImage(
      source: ImageSource.gallery,
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
      appBar: AppBar(
        title: const Text('Escanear página'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SizedBox(
              height: 260,
              child: Center(
                child: temImagem
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(
                          _imagemBytes!,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      )
                    : const _ScanPlaceholder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _carregando ? null : _selecionarImagem,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(
                temImagem ? 'Trocar imagem' : 'Escolher imagem da página',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed:
                  _carregando || !temImagem ? null : _reconhecerAutomaticamente,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Reconhecer automaticamente'),
            ),
            
            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: _carregando || !temImagem ? null : _girarImagem,
              icon: const Icon(Icons.rotate_90_degrees_cw),
              label: const Text('Girar imagem'),
            ),
            
            if (temTextoOcr) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _mostrarTextoOcr,
                icon: const Icon(Icons.subject),
                label: const Text('Ver texto reconhecido'),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              'Gerar códigos da página',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'O OCR tenta detectar a seleção pela foto. Se não conseguir com segurança, escolha a seleção manualmente e confirme quais figurinhas estão coladas.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<_SelecaoScan>(
              value: _selecaoSelecionada,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Seleção',
              ),
              items: _selecoes.map((selecao) {
                return DropdownMenuItem<_SelecaoScan>(
                  value: selecao,
                  child: Text(
                    '${selecao.nome} (${selecao.prefixo}) - ${selecao.codigos.length}',
                  ),
                );
              }).toList(),
              onChanged: _carregando ? null : _aplicarSelecao,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _prefixoController,
                    enabled: !_carregando,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Prefixo',
                      hintText: 'MEX',
                    ),
                    onChanged: (_) => _gerarCodigos(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _inicioController,
                    enabled: !_carregando,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Início',
                    ),
                    onChanged: (_) => _gerarCodigos(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _fimController,
                    enabled: !_carregando,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fim',
                    ),
                    onChanged: (_) => _gerarCodigos(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _carregando ? null : _gerarCodigos,
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('Gerar códigos'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codigosController,
              enabled: !_carregando,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Códigos reconhecidos ou gerados',
                hintText: 'Exemplo: MEX1, MEX2, MEX3...',
              ),
            ),
            const SizedBox(height: 24),
            if (_carregando)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Analisando imagem ou preparando confirmação...'),
                  ],
                ),
              )
            else
              FilledButton.icon(
                onPressed: _continuarParaConfirmacao,
                icon: const Icon(Icons.checklist_outlined),
                label: const Text('Continuar para confirmação'),
              ),
            const SizedBox(height: 16),
            const Text(
              'O reconhecimento automático é apenas uma ajuda. Sempre confira os códigos antes de continuar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanPlaceholder extends StatelessWidget {
  const _ScanPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.document_scanner_outlined,
            size: 72,
          ),
          SizedBox(height: 16),
          Text(
            'Escolha uma foto da página',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'O app tentará reconhecer a seleção automaticamente.',
            textAlign: TextAlign.center,
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