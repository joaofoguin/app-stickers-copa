import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/scan_result.dart';
import '../services/album_scan_service.dart';
import '../services/web_ocr_service.dart';
import 'scan_result_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

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

  final List<_SelecaoScan> _selecoes = const [
    _SelecaoScan(nome: 'México', prefixo: 'MEX', quantidade: 20),
    _SelecaoScan(nome: 'África do Sul', prefixo: 'RSA', quantidade: 20),
    _SelecaoScan(nome: 'Brasil', prefixo: 'BRA', quantidade: 20),
    _SelecaoScan(nome: 'Argentina', prefixo: 'ARG', quantidade: 20),
    _SelecaoScan(nome: 'Estados Unidos', prefixo: 'USA', quantidade: 20),
  ];

  _SelecaoScan? _selecaoSelecionada;

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
      final prefixoDetectado = _scanService.detectarPrefixoDoTexto(textoExtraido);

      if (prefixoDetectado != null) {
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
              'Seleção detectada: $prefixoDetectado. Códigos gerados automaticamente.',
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
            'Não consegui reconhecer a seleção automaticamente. Escolha a seleção manualmente ou gere pelos campos abaixo.',
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

  void _aplicarSelecao(_SelecaoScan? selecao) {
    if (selecao == null) return;

    setState(() {
      _selecaoSelecionada = selecao;
      _prefixoController.text = selecao.prefixo;
      _inicioController.text = '1';
      _fimController.text = selecao.quantidade.toString();
      _gerarCodigos();
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

    final codigos = List.generate(
      fim - inicio + 1,
      (index) => '$prefixo${inicio + index}',
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

      final codigosConfirmados = await Navigator.push<List<String>>(
        context,
        MaterialPageRoute(
          builder: (_) => ScanResultPage(resultado: resultado),
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
              'Você pode reconhecer pela foto, escolher a seleção ou informar o prefixo manualmente. Depois confirme quais figurinhas estão coladas.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<_SelecaoScan>(
              value: _selecaoSelecionada,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Seleção',
              ),
              items: _selecoes.map((selecao) {
                return DropdownMenuItem<_SelecaoScan>(
                  value: selecao,
                  child: Text('${selecao.nome} (${selecao.prefixo})'),
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
              'O reconhecimento automático pode errar alguns códigos. Confira o campo antes de continuar.',
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
            'O app tentará reconhecer os códigos automaticamente.',
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
  final int quantidade;

  const _SelecaoScan({
    required this.nome,
    required this.prefixo,
    required this.quantidade,
  });
}