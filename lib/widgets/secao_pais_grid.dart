import 'package:flutter/material.dart';

import '../models/figurinha.dart';
import '../utils/pais_utils.dart';
import 'figurinha_bottom_sheet.dart';
import 'figurinha_grid_tile.dart';

class SecaoPaisGrid extends StatelessWidget {
  final String pais;
  final List<Figurinha> figurinhas;
  final int totalPais;
  final int tenhoPais;
  final String resumo;
  final void Function(Figurinha figurinha, bool valor) onMarcar;
  final void Function(Figurinha figurinha) onAdicionarRepetida;
  final void Function(Figurinha figurinha) onRemoverRepetida;

  const SecaoPaisGrid({
    super.key,
    required this.pais,
    required this.figurinhas,
    required this.totalPais,
    required this.tenhoPais,
    required this.resumo,
    required this.onMarcar,
    required this.onAdicionarRepetida,
    required this.onRemoverRepetida,
  });

  void abrirAcoesFigurinha(BuildContext context, Figurinha figurinha) {
    showModalBottomSheet(
      context: context,
      showDragHandle: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return FigurinhaBottomSheet(
          figurinha: figurinha,
          onMarcar: (valor) {
            onMarcar(figurinha, valor);
          },
          onAdicionarRepetida: () {
            onAdicionarRepetida(figurinha);
          },
          onRemoverRepetida: () {
            onRemoverRepetida(figurinha);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bandeira = bandeiraEmojiPais(pais);
    final sigla = nomeReduzidoPais(pais);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 12),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Text(
                bandeira,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$pais ($sigla)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: Text(
                  resumo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        GridView.builder(
          itemCount: figurinhas.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final figurinha = figurinhas[index];

            return FigurinhaGridTile(
              figurinha: figurinha,
              onTap: () => abrirAcoesFigurinha(context, figurinha),
            );
          },
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}