import 'package:flutter/material.dart';

import '../models/figurinha.dart';
import '../utils/numero_album_utils.dart';
import '../utils/pais_utils.dart';

class FigurinhaGridTile extends StatelessWidget {
  final Figurinha figurinha;
  final VoidCallback onTap;

  const FigurinhaGridTile({
    super.key,
    required this.figurinha,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool tenho = figurinha.tenho;
    final bool repetida = figurinha.repetidas > 0;

    final Color borda = repetida
        ? Colors.blue.shade400
        : tenho
            ? Colors.green.shade500
            : Colors.grey.shade300;

    final Color fundo = repetida
        ? Colors.blue.shade50
        : tenho
            ? Colors.green.shade50
            : Colors.white;

    final sigla = prefixoNumeroAlbum(figurinha.numeroAlbum);
    final numero = numeroVisualAlbum(figurinha.numeroAlbum);
    final bandeira = bandeiraEmojiPais(figurinha.pais);

    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: fundo,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borda,
              width: tenho ? 2 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$sigla ${bandeira.isEmpty ? '' : bandeira}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Text(
                        numero,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              if (tenho)
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.shade600,
                    size: 18,
                  ),
                ),

              if (figurinha.repetidas > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'x${figurinha.repetidas}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
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