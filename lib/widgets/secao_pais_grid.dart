import 'package:flutter/material.dart';

import '../models/figurinha.dart';
import '../theme/app_colors.dart';
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
      backgroundColor: Colors.transparent,
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

  void aoTocarFigurinha(BuildContext context, Figurinha figurinha) {
    if (!figurinha.tenho) {
      onMarcar(figurinha, true);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${figurinha.numeroAlbum} marcada como preenchida'),
          duration: const Duration(seconds: 1),
        ),
      );

      return;
    }

    abrirAcoesFigurinha(context, figurinha);
  }

  @override
  Widget build(BuildContext context) {
    final bandeira = bandeiraEmojiPais(pais);
    final sigla = nomeReduzidoPais(pais);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(8, 14, 8, 14),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(
                bandeira,
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$pais ($sigla)'.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                resumo.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        GridView.builder(
          itemCount: figurinhas.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final figurinha = figurinhas[index];

            return FigurinhaGridTile(
              figurinha: figurinha,
              onTap: () {
                aoTocarFigurinha(context, figurinha);
              },
              onLongPress: () {
                abrirAcoesFigurinha(context, figurinha);
              },
            );
          },
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}